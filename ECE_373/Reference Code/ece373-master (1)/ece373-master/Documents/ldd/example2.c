/*
 * PJ Waskiewicz
 * 6/28/2011
 * ECE 373
 *
 * Example 2: Register a device node
 */

#include <linux/module.h>
#include <linux/types.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>

#define DEVCNT 5
static dev_t mydev_node;

static int __init example2_init(void)
{
	int ret = 0;

	printk(KERN_INFO "example2 module loading...\n");

	mydev_node = 0xff00000; /* DON'T DO THIS!! */
	//mydev_node = 0x0700000; /* DON'T DO THIS!! */

	ret = register_chrdev_region(mydev_node, DEVCNT, "example2");
	if (ret) {
		printk(KERN_ERR "Register chardev failed! ret=%d\n", ret);
		return ret;
	}

	return ret;
}

static void __exit example2_exit(void)
{
	/* clean up the devices */
	unregister_chrdev_region(mydev_node, DEVCNT);

	printk(KERN_INFO "example2 module unloaded!\n");
}

MODULE_AUTHOR("PJ Waskiewicz");
MODULE_LICENSE("GPL");
MODULE_VERSION("0.2");
module_init(example2_init);
module_exit(example2_exit);
