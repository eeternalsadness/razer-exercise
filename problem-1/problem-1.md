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
Security, High Availability / Reliability, Scalability, Performance and Observability.

## Assumptions

- **Global service**:
  - The service needs to be available globally, so a public cloud solution is appropriate
  - The service likely needs to be deployed in multiple regions to ensure quality of service and availability/disaster recovery
- **External/Internal API service**:
  - External and internal users/systems interact through APIs, so API gateways are necessary
- **Payment processor integration service**:
  - The system integrates with an external payment processor which does most of the heavy lifting (checking balance, fraud detection, money transfers, etc.)

## Requirements

### Functional Requirements

### Non-functional Requirements

## High-Level Design

### Network Diagram

### System Architecture

## Considerations

### Security

### High Availability/Reliability

### Scalability

### Performance

### Observability
