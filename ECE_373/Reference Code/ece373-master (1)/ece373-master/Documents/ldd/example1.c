/*
 * PJ Waskiewicz
 * 6/28/2011
 * ECE 373
 *
 * Example 1: Create a device node
 */

#include <linux/module.h>
#include <linux/types.h>
#include <linux/kdev_t.h>

static int __init example1_init(void)
{
	dev_t mydev_node;

	printk(KERN_INFO "example1 module loading...\n");

	mydev_node = 0x007000ff; /* DON'T DO THIS!! */

	printk(KERN_INFO "Major number: %d, Minor number: %d\n",
	       MAJOR(mydev_node), MINOR(mydev_node));

	return 0;
}

static void __exit example1_exit(void)
{
	printk(KERN_INFO "example1 module unloaded!\n");
}

MODULE_AUTHOR("PJ Waskiewicz");
MODULE_AUTHOR("Shannon Nelson");
MODULE_LICENSE("GPL");
MODULE_VERSION("0.2");
module_init(example1_init);
module_exit(example1_exit);
