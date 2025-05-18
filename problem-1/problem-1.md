# Problem 1

## Problem Statement

Team Snake is working on a new project that serves payment services globally. They have the
following services to be deployed:

- Web server
- External API Service
- Internal API Service
- Payment Processor Integration Service
- Redis Cache
- Relational Database

Please provide a network architecture diagram, as well as suitable solutions that considers
Security, High Availability/Reliability, Scalability, Performance and Observability.

## Assumptions

- **Global service**:
  - The service needs to be available globally, so a public cloud solution is appropriate
  - The service likely needs to be deployed in multiple regions to ensure quality of service and availability/disaster recovery
  - Each region likely has its own payment processors with different regulations, so there is no need for inter-region communication
- **External/Internal API service**:
  - External and internal users/systems interact through APIs, so API gateways are necessary
- **Payment processor integration service**:
  - The system integrates with an external payment processor which does most of the heavy lifting (checking balance, fraud detection, money transfers, etc.)

## Requirements

### Functional Requirements

- A user-facing web front that's available globally
- Interaction with external and internal services through APIs
- Deploy the following services:
  - External API service
  - Internal API service
  - Payment processor integration service
- Ability to handle large transaction volumes (thousands of requests per second)
- Use an ACID-compliant relational database to store financial transactions
- Use Redis as cache for the database(s)

### Non-functional Requirements

- The system should be highly available
- Data should be encrypted at rest and in transit
- Compliance with standards such as PCI DSS or KYC
- Requests should have low latency

## High-Level Design

![architecture-diagram](/problem-1/architecture-diagram.png)

On the global level, Route 53 routes web traffic to the appropriate CloudFront distributions that are backed by S3 (using Origin Access Control for security). Mobile clients and external API calls are routed to the appropriate regional API gateways. Amazon WAF and Shield are deployed to secure the inbound connections. CloudFront and API Gateways are set up with necessary certificates with AWS ACM.

Traffic from a regional API gateway is routed to a network load balancer that distributes traffic to ECS services in multiple availability zones (AZ). A network load balancer should offer higher throughput and lower latency than an application load balancer.

ECS services communicate with each other asynchronously through message queues (SQS, Kafka, etc.). If necessary, a private API gateway can also be used. The payment processor integration service can communicate with external APIs through the respective NAT gateway in each AZ. The NAT gateways should make it easier for the external payment services to whitelist the team's IP addresses. Appropriate security groups and network ACLs should be set up to make sure the outbound traffic is secure.

RDS should be deployed in a multi-AZ setup for high availability, with regular backups to ensure RTO and RPO. The databases can be sharded based on user/client ID to keep up with the high volume of requests. There should also be a message queue that acts as a buffer for the databases. ElastiCache for Redis should be deployed as a caching layer for the databases to ease off read operations.

Additional AWS services such as GuardDuty, AWS Config, and AWS Secrets Manager can be used to improve security. Observability can be achieved through CloudWatch, CloudTrail, and OpenSearch, or through third-party services like Prometheus, Grafana, and ELK.

## Considerations

### Security

### High Availability/Reliability

### Scalability

### Performance

### Observability
