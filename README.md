# Custom OCI images

A very basic but complete example on how to build custom images on Oracle Cloud Infrastructure.

## Overview

Custom images are a great way to have a system with complex software dependencies and configurations
setup ahead of time and quickly deployed whenever needed. In its simplest form one would start up an
instance of a particular shape, log in, perform all package installations and the custom configurations,
log out, and generate a custom image from the shape. But this can be automated!

[packer](https://packer.io) allows you to script your image generation. Furthermore, Ansible, gives you a
flexible way to configure and automate the customization steps on the target shape. The two tools
together can then be used to provision a machine of a desired shape, automatically customize the
image on the running system, generate the final image and then tear the build system back down.


## How to use this example

1. Create a `variables.pkrvars.hcl` file
2. Fill in a few basic parameters needed for the image customization

```
compartment_id = "ocid1.tenancy..."
subnet_id = "ocid1.subnet..."
shape = "VM.Standard.E2.1"
```

3. Run packer

```bash
packer build --var-file=variables.pkrvars.hcl  pytorch_custom_image.pkr.hcl
```

4. If the build process passed without a hitch, edit the `pytorch_custom_image.pkr.hcl` file setting
   the `skip_create_image` property to `False` and rerun.

And you're done!
