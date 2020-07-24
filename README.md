# External Authorizer

## Description

Credit card authorization is the process run in each purchase transaction to decide if it can be completed or not, it includes validating pin code and chip, checking if the client has the funds to cover the cost of the transaction and checking if the transaction is fraudulent.

Zippi will build its own External Authorization infrastructure, so we can customize the business logic, specifically, the step that checks if the incoming transaction value can be covered by the client's current available limit.This infra-structure has to be separated from the main app, due to server localization requirements from our vendor. The external authorizer and the main app have to be kept in sync, so that both systems are seeing the same value for the available limit. Note that the available limit on the card can change either by actions that happen on the authorizer (incoming purchases) and by actions that happen on the main app, like repayments, limit increases,  and late fee charges, for example; so both systems send updates to each other.

**This prompt only focuses on the purchase transaction authorization, so you must build this part of the external authorizer. It will receive a request from the processor with the transaction information and the system must process the transaction, sending it to Zippi's main system, and return the correct status.**

## Coding

We provided you a virtual environment with the correct dependencies but it may not load the gems at startup, to install them run `bundle install` in the terminal.

In this environment there's the base Rails app needed to implement the solution. To test it, we provided the rspec file, it should serve as the documentation of how the solution should behave. In order to run the tests, just run the command `rspec`, we expect to see all tests running as shown below:

```
> rspec 
............

Finished in 0.14341 seconds (files took 1.2 seconds to load)
12 examples, 0 failures
```


The code provided is a starting point to your solution: you may change it as you want to make it more comfortable to you or to improve it from a tech point of view, for instance, by adding helper methods, libs or changing the app architecture. **We expect to see good practices regarding CS principles, like layers responsibility and code maintainability, for example. The tests should be more a guide to your solution than the objective of the prompt itself.**

### Specs
- Mediators - layer responsible for the interface between the system and external services. 
  - `ZippiMediator` is the interface with Zippi's main system and must be called for every authorized purchase transaction.
- Models
  - `CreditCard` - holds the `id` to identify the card, the `status` of the card and the available limit in cents `limit_cents`
- Controllers
  - `TransactionController` - defines the method `create` that is exposed in a route that the processor sends the purchase transactions


## Extra
The response time of the external authorizer wasn't considered in this prompt but it's a huge constraint of the system. Considering that the request to Zippi's main system may take longer than the time that the authorizer has to respond to the processor, what solutions could we build in this case? It's not necessary to implement the solution.

## Troubleshooting

### How do I build a Gitpod?

Gitpod is an online environment that can be mounted from Git repositories. Go to their [landing page](https://www.gitpod.io/#get-started) and add the link of this repository to mount a new environment.

### Your Ruby version is 2.6.6, but your Gemfile specified 2.5.5

Gitpod comes with a different version of Ruby, you should change these lines of the `Gemfile`
```ruby
# before
ruby '2.5.5'

# after
ruby '2.6.6'
```

This version was tested but if you find any unexpected behavior you can use [this branch](https://github.com/zippi-tech/ext-auth-interview/tree/italo/add-gitpod) to deploy on Gitpod, following the step above. It takes longer than the default but it installs the correct version of Ruby,