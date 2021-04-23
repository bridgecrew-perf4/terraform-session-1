### Tags with locals.tf
Tags comparison with/without locals.tf file. When you use the same environment and project name , instead of repeating it over and over again, you can use locals.tf where you describe all the common tags, and merge it to another tags in the resource block.

Before when you don't use locals.tf:
```
tags = {
  Name        = "${var.env}_sg"
  Environment = var.env
  Project     = var.project_name
}
```

Describing the common tags that we are using in our resource block, content of the locals.tf
```
locals {
  common_tags = {
    Environment = var.env
    Project     = var.project_name
  }
}
```
After that we just have to merge common tags with the given tags, and it will look like this:
```
tags = merge(
  local.common_tags,
  {
    Name = "${var.env}_sg"
  }
)
```