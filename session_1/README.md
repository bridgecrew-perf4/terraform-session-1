## Terraform introdution

#### What is IaaC (Infrastructure as a Code)?

To start with let's read what the official documentation says about IaaC.``` It is the process of managing infrastructure in a file or files rather than manually configuring resources in a user interface. A resource in this instance is any piece of infrastructure in a given environment, such as a virtual machine, security group, network interface, etc.``` Infrastructure as a Code allows companies to more efficiently to build and control the changes of their infrastructure in the cloud environment. The idea behind of IaaC is to automate building your infra instead of manualy creating it on the console (GUI), which usually causes human error, to avoid that  IaaC tools like: Terraform, Cloudformation comes very handy. So with that developers can concentrate more on building their product. Pluses of using IaaC tools are:

- speed: to build manually takes time, but to run your code minutes especially when we talk about huge infra or 100s of instances. Perfect for disaster recovery. 
- consistency: you run template in different availability zones you will get exactly same output, nothing changes. Unless you add/remove some extra resources depending of the environment. 
- reusable code: you write it once and reuse it as many time as you want.
- lowers our costs: it's perfect for fast building and destroying, you can build your website in the morning and destroy it in the evening, so it doesn't have to run all night.

#### What is the difference between immutable vs mutable infra?

When we talk about mutable infra we mean, that after some time of creating your infra in the cloud, one day you have to update a version of our software or just simply decided to switch to different software. So we do those changes, that means your infrastructure changes over time. Typically those kind of changes are done with ```configuration management``` tools such as Chef, Ansible or Puppet, it is very easy to to do it using listed above tools. All you are going to is performing upgrades of your infra, but Terraform is not recommemded for that use. We build our infra and if we decide to add/remove some more resources we just build a new infra parallel to that infra that we have, and if everything is good, we destroy an older version of our infra and reroute the traffic to our new infra. So that way our customers don't have any issues connecting to our website and that is called ```immutable```. 
Mutable infra changes over time and ummutable doesn't change, it simply will be rebuild over again.

#### What is the difference between imperative and declarative approach?

Imperative approach answers to a question ```HOW?``` How do you achive a certain goal? In a simple language imperative is a procedural approach where we give detailed instructions of ```HOW?``` to achive what we want.

Declarative approach we have to answer to a question ```WHAT?``` here instead of giving instructions how to achive our end goal, we just say what we want to achive at the end. We simply describe desired end state and tool as Terraform smart enough to get what it needs from the configuration files we provided.

#### What is the idempotence?

Idempotence in programming is a property of some operations such that no matter how many times you execute them, you achive the same result. If we take as an example Terraform once our infrastructure up and running if we run our code again it will go and check real world infra and compares state file with it and says "Nothing to change. Everything is up to date".

### Useful Links

[Introduction to Infrastructure as Code with Terraform](https://learn.hashicorp.com/tutorials/terraform/infrastructure-as-code)

[What is Mutable vs. Immutable Infrastructure?](https://www.hashicorp.com/resources/what-is-mutable-vs-immutable-infrastructure)

[Comparing Declarative & Imperative Sentences](https://study.com/academy/lesson/comparing-declarative-imperative-sentences.html)

[Idempotence](https://whatis.techtarget.com/definition/idempotence)