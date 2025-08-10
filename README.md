## Here is folder structure of this project

### Our principal are separate tf state for each environment and for each module.
- `00-bootstrap` to initialize tf state
- `01-infras` to define all resources which are not use `CPU` and `RAM`
- `02-workload` to define all resources to run our application services such as: ECS, RDS, EKS ...
- `modules` to define all reusable tf code and it is pure tf code.