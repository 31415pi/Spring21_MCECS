/*
 * PJ Waskiewicz
 * 6/28/2011
 * ECE 373
 *
 * Example 3: Dynamically allocate a device node
 */

#include <linux/module.h>
#include <linux/types.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>

#define DEVCNT 5
static dev_t mydev_node;

static int __init example3_init(void)
{
	int ret = 0;

	printk(KERN_INFO "example3 module loading...\n");

	ret = alloc_chrdev_region(&mydev_node, 0, DEVCNT, "example3");
	if (ret) {
		printk(KERN_ERR "alloc_chrdev_region() failed! ret=%d\n", ret);
		return ret;
	}

	printk(KERN_INFO "Allocated %d devices at major: %d\n",
	       DEVCNT, MAJOR(mydev_node));

	return ret;
}

static void __exit example3_exit(void)
{
	/* clean up the devices */
	unregister_chrdev_region(mydev_node, DEVCNT);

	printk(KERN_INFO "example3 module unloaded!\n");
}

MODULE_AUTHOR("PJ Waskiewicz");
MODULE_LICENSE("GPL");
MODULE_VERSION("0.2");
module_init(example3_init);
module_exit(example3_exit);
