# CHANGELOG 📜
All notable changes to this script will be documented in this file 🙌🏽

## [1.0.0]
### Added ➕
- Initial release of Terraform multi-environment infrastructure project.
- Modular architecture with `network`, `loadbalancer`, `compute`, and `database` child modules.
- Separate environment configurations for `dev`, `stage`, and `prod`.
- GitLab CI/CD pipeline integrated for automated validation, planning, and deployment.
- Initial testing phase focused on the `dev` environment at the moment to make sure pipeline is responding correctly.
- Basic `install_nginx.sh` bootstrap script for compute instances.
- Remote backend configured using AWS S3 for state management.

### Updated 🔄 
- 📝 README.md with project details and credits section.
- ⚠️ Further refinements to README might still be needed.
