+++
title = "The Serverless Engine"
description = "Apache OpenWhisk: an asynchronous, self-scaling, event-driven engine, and what happens internally when an action is invoked."
weight = 20
+++

The serverless engine is Apache OpenWhisk. The architecture is shown in Figure 2.

OpenWhisk is a self-scalable system, leveraging a load balancer that efficiently distributes incoming workload. It operates asynchronously, meaning that all requests are first routed through Kafka, which acts as a request collector. Kafka then distributes these requests to the invokers, allowing the system to handle high loads without dropping any requests.

Furthermore, OpenWhisk is a serverless platform with built-in runtimes for various programming languages. This serverless design enables developers to skip the container-building process: simply writing functions is sufficient, as the runtimes execute them directly without the need to create custom images.

It runs functions (called actions) in response to various events, such as those from timers, databases, message queues, or platforms like Slack and GitHub. Developers input source code via a command-line interface (CLI) to trigger functions, which then deliver services over the web to various consumers, including websites, mobile applications, or REST API-based services.

In OpenWhisk, functions are stateless by design, meaning they don't retain data between executions, which enables scalability by avoiding complex synchronization of state. Stateful applications, like e-commerce sites with shopping carts, require data storage and synchronization, limiting scalability. Serverless environments avoid these issues by using scalable storage, such as NoSQL databases, when state is needed outside individual functions.

OpenWhisk waits for events and only invokes functions when events occur. This event-driven model allows developers to focus on code that responds to specific triggers, while the cloud infrastructure handles the rest, supporting applications built from simple, stateless actions triggered by events.

![The Apache OpenWhisk architecture](_page_6_Picture_2.jpeg)

**Figure 2**

## How an action is executed

OpenWhisk operates through a series of internal steps when executing an action, leveraging several open-source tools. Here's how it works:

1. **Invocation and Nginx**: Actions can be triggered via the web, API, CLI, or triggers. Each invocation is translated to an HTTPS call, which reaches Nginx, acting as a reverse proxy for secure communication. Nginx forwards the request to OpenWhisk's controller.
2. **Controller**: The controller verifies the request through authentication, authorization, and enriches it with additional parameters by consulting CouchDB (the system's NoSQL database). It then directs the action to the load balancer.
3. **Load Balancer**: This component decides which invoker (executor) to assign to the action based on availability, creating new instances as needed. If resources aren't immediately available, the request is queued in Kafka, OpenWhisk's messaging system, until it's ready to execute.
4. **Invoker**: The invoker runs the action inside a Docker container, using images suited to different languages (JavaScript, Python, etc.). It initialises the container with the action's code and manages logs for debugging. Results are then stored in CouchDB, associated with an activation ID.
5. **Client Interaction**: For asynchronous execution, the client receives an activation ID, which they can later use to retrieve the result from CouchDB. In synchronous execution, the client waits for immediate results.

This system enables OpenWhisk to handle requests in a scalable, asynchronous manner by decoupling action execution from state-keeping, ensuring efficiency and flexibility in serverless environments.

Next: [Nuvolaris Components](@/architecture/components.md).
