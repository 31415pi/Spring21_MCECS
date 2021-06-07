/*
 * PJ Waskiewicz
 * 5/11/2021
 *
 * Driver for ECE373 to probe and instantiate cdev's in the probe
 *
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/device.h>
#include <linux/timer.h>
#include <linux/delay.h>
#include <linux/types.h>
#include <linux/kdev_t.h>
#include <linux/cdev.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <linux/kref.h>
#include <linux/pci.h>

#define DEVNAME "ece_probe"

/* Forward declarations for the compiler */
int ece_probe_open(struct inode *inode, struct file *file);
int ece_probe_release(struct inode *inode, struct file *file);
ssize_t ece_probe_read(struct file *file, char __user *buf,
                     size_t len, loff_t *offset);

/* Class for our auto-generated /dev entry */
static struct class *ece_probe_driver_class;

/* Private driver data structure */
struct ece_probe_dev {
	struct pci_dev *pdev; /* back-pointer to our parent pdev */
	dev_t ece_probe_node;
	struct cdev ece_probe_cdev;

	/* BAR0 address */
	void __iomem *hw_addr;
};

/* File operations for our system calls */
static struct file_operations ece_probe_driver_fops = {
	.owner = THIS_MODULE,
	.open = ece_probe_open,
	.read = ece_probe_read,
	.release = ece_probe_release,
};

static struct pci_device_id ece_probe_pci_tbl[] = {
	{ PCI_DEVICE(0x8086, 0x100e) },
	{ } /* Terminating entry - this is required */
};
MODULE_DEVICE_TABLE(pci, ece_probe_pci_tbl);

int ece_probe_open(struct inode *inode, struct file *file)
{
	/*
	 * Only purpose is to save off our private data structure for
	 * the other system calls to use.  Prevents the need for ugly globals.
	 */
	struct ece_probe_dev *ece_probe;

	ece_probe = container_of(inode->i_cdev,
				 struct ece_probe_dev,
				 ece_probe_cdev);
	file->private_data = ece_probe;

	return 0;
}

int ece_probe_release(struct inode *inode, struct file *file)
{
	/* clear the private_data member just to be safe */
	file->private_data = NULL;

	return 0;
}

ssize_t ece_probe_read(struct file *file, char __user *buf,
		       size_t len, loff_t *offset)
{
	struct ece_probe_dev *ece_probe = file->private_data;
	char *kern_buf;

	/* verify the buffer we have is ok */
	if (!buf)
		return -EINVAL;

	kern_buf = vmalloc(len);
	if (!kern_buf)
		return -ENOMEM;

	/* do stuff... */

	printk(KERN_INFO "Reading from major dev: %d\n", MAJOR(ece_probe->ece_probe_node));

	vfree(kern_buf);
	return len;
}

/* probe time */
static int ece_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
{
	int err;
	struct ece_probe_dev *ece_probe;
	resource_size_t mmio_start, mmio_len;

	/* create our driver struct */
	ece_probe = kzalloc(sizeof(struct ece_probe_dev), GFP_KERNEL);
	if (!ece_probe) {
		err = -ENOMEM;
		goto err_alloc_dev;
	}

	/* Do the chardev setup in probe so we don't need globals */

	/* chardev creation and setup */
	err = alloc_chrdev_region(&ece_probe->ece_probe_node, 0, 1, DEVNAME);
	if (err) {
		dev_err(&pdev->dev, "alloc_chrdev_region() failed: %d\n", err);
		goto err_alloc_chardev;
	}

	cdev_init(&ece_probe->ece_probe_cdev, &ece_probe_driver_fops);
	ece_probe->ece_probe_cdev.owner = THIS_MODULE;
	err = cdev_add(&ece_probe->ece_probe_cdev, ece_probe->ece_probe_node, 1);
	if (err) {
		dev_err(&pdev->dev, "cdev_init() failed: %d\n", err);
		goto err_cdev_init;
	}

	/*
	 * TODO: for the reader - probe on multiple instances, but only
	 * create the class once, and then create counts of minor devs
	 */

	/* device class setup and device creation */
	ece_probe_driver_class = class_create(THIS_MODULE, "ece_probe");
	device_create(ece_probe_driver_class, NULL, ece_probe->ece_probe_node,
	              NULL, DEVNAME);

	err = pci_request_selected_regions(pdev,
	                                  pci_select_bars(pdev, IORESOURCE_MEM),
	                                  DEVNAME);
	if (err)
		goto err_pci_reg;

	/* enable bus mastering - needed for descriptor writebacks */
	pci_set_master(pdev);

	/* save off our driver struct for later */
	ece_probe->pdev = pdev;
	pci_set_drvdata(pdev, ece_probe);

	/* finish mapping the BAR */
	mmio_start = pci_resource_start(pdev, 0);
	mmio_len = pci_resource_len(pdev, 0);

	ece_probe->hw_addr = ioremap(mmio_start, mmio_len);
	if (!ece_probe->hw_addr)
		goto err_ioremap;

	/* all done! */
	return 0;

	/* error handling */
err_ioremap:
	pci_release_selected_regions(pdev,
	                             pci_select_bars(pdev, IORESOURCE_MEM));
err_pci_reg:
	/* destroy the dev entry */
	device_destroy(ece_probe_driver_class, ece_probe->ece_probe_node);
	class_destroy(ece_probe_driver_class);
err_cdev_init:
	unregister_chrdev_region(ece_probe->ece_probe_node, 1);
err_alloc_chardev:
	kfree(ece_probe);
err_alloc_dev:
	return err;
}

/* remove */
static void ece_probe_remove(struct pci_dev *pdev)
{
	struct ece_probe_dev *ece_probe;

	ece_probe = pci_get_drvdata(pdev);

	/* start tearing down */

	/* destroy the dev entry */
	device_destroy(ece_probe_driver_class, ece_probe->ece_probe_node);
	class_destroy(ece_probe_driver_class);

	/* tear down the cdev */
	cdev_del(&ece_probe->ece_probe_cdev);
	unregister_chrdev_region(ece_probe->ece_probe_node, 1);

	/* unmap the BAR */
	iounmap(ece_probe->hw_addr);
	pci_release_selected_regions(pdev,
	                             pci_select_bars(pdev, IORESOURCE_MEM));
}

/* PCI driver interface */
static struct pci_driver ece_probe_driver = {
	.name = DEVNAME,
	.id_table = ece_probe_pci_tbl,
	.probe = ece_probe,
	.remove = ece_probe_remove,
};

static int __init ece_probe_driver_init(void)
{
	/* Register the PCI device */
	return pci_register_driver(&ece_probe_driver);
}

static void __exit ece_probe_driver_exit(void)
{
	/* unregister the PCI driver */
	pci_unregister_driver(&ece_probe_driver);
}

module_init(ece_probe_driver_init);
module_exit(ece_probe_driver_exit);

MODULE_AUTHOR("PJ Waskiewicz");
MODULE_LICENSE("GPL");
MODULE_VERSION("0.1");
