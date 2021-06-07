/*
 * PJ Waskiewicz
 * 5/10/2021
 * ECE 373
 *
 * Class create example
 */

#include <linux/module.h>
#include <linux/types.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/slab.h>
#include <linux/uaccess.h>

#define DEVCNT 5
#define DEVNAME "class_create"

static struct class *class_create_example;

static struct mydev_dev {
	dev_t mydev_node;
	struct cdev my_cdev;
	/* more stuff will go in here later... */
	int sys_int;
} mydev;

static int class_create_open(struct inode *inode, struct file *file)
{
	printk(KERN_INFO "successfully opened!\n");

	mydev.sys_int = 23;

	return 0;
}

/* File operations for our device */
static struct file_operations mydev_fops = {
	.owner = THIS_MODULE,
	.open = class_create_open,
};

static int __init class_create_init(void)
{
	printk(KERN_INFO "class_create example loading\n");

	if (alloc_chrdev_region(&mydev.mydev_node, 0, DEVCNT, DEVNAME)) {
		printk(KERN_ERR "alloc_chrdev_region() failed!\n");
		return -1;
	}

	printk(KERN_INFO "Allocated %d devices at major: %d\n", DEVCNT,
	       MAJOR(mydev.mydev_node));

	/* Initialize the character device and add it to the kernel */
	cdev_init(&mydev.my_cdev, &mydev_fops);
	mydev.my_cdev.owner = THIS_MODULE;

	if (cdev_add(&mydev.my_cdev, mydev.mydev_node, DEVCNT)) {
		printk(KERN_ERR "cdev_add() failed!\n");
		/* clean up chrdev allocation */
		unregister_chrdev_region(mydev.mydev_node, DEVCNT);

		return -1;
	}

	/* now instantiate the device class hierarchy, and create the device */
	class_create_example = class_create(THIS_MODULE, DEVNAME);
	device_create(class_create_example, NULL, mydev.mydev_node,
		      NULL, DEVNAME);

	return 0;
}

static void __exit class_create_exit(void)
{
	/* destroy the dev entry and device class */
	device_destroy(class_create_example, mydev.mydev_node);
	class_destroy(class_create_example);

	/* destroy the cdev */
	cdev_del(&mydev.my_cdev);

	/* clean up the devices */
	unregister_chrdev_region(mydev.mydev_node, DEVCNT);

	printk(KERN_INFO "class_create module unloaded!\n");
}

MODULE_AUTHOR("PJ Waskiewicz");
MODULE_LICENSE("GPL");
MODULE_VERSION("0.1");
module_init(class_create_init);
module_exit(class_create_exit);
