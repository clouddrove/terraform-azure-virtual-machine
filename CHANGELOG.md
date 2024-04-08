# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2024-04-08
### :bug: Bug Fixes
- [`7235597`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/7235597efdf3cb28e6fcc5a27b24729388483937) - add default value in variable.tf *(commit by [@themaheshyadav](https://github.com/themaheshyadav))*
- [`2006d4d`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/2006d4db119a57c7d54aab021650c8d89be04e5c) - add role assin and ad extension *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*
- [`b8b7536`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/b8b7536166ffb237c359a34d118223f29ff90800) - update automerge *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*
- [`5f1c076`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/5f1c07685eac22b56b588b55484041604423bf72) - update ad extension for windows *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*
- [`da11177`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/da11177f1c0c267425b0ca6c972ca03cd0936334) - update workflows version *(commit by [@mamrajyadav](https://github.com/mamrajyadav))*
- [`8a71132`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/8a711329cd42cec111b1a56bfaeb3642a929c605) - naming fix for disk encryption *(commit by [@d4kverma](https://github.com/d4kverma))*
- [`29b2f1b`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/29b2f1b360c02529c081a166fa41ba7deb059264) - remove diagnosis setting attributes *(commit by [@d4kverma](https://github.com/d4kverma))*
- [`12b83e5`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/12b83e5fb66e3d1d431ef610027651654fe3f5ab) - default variables *(PR [#51](https://github.com/clouddrove/terraform-azure-virtual-machine/pull/51) by [@d4kverma](https://github.com/d4kverma))*
- [`379ea57`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/379ea5789461581339d49eec00e57b237ebf75ad) - change in count condition *(PR [#53](https://github.com/clouddrove/terraform-azure-virtual-machine/pull/53) by [@Rupalgw](https://github.com/Rupalgw))*

### :construction_worker: Build System
- [`c0164b6`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/c0164b62da68b96fe5c2a98c130f2232bd3ce768) - **deps**: bump clouddrove/github-shared-workflows *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`b66f678`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/b66f678ee173371329f221074e3dbf0a82d7aa59) - **deps**: bump pre-commit/action from 3.0.0 to 3.0.1 *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*
- [`5413805`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/5413805359e0b632d14eefd0c98f7c83eccef27a) - **deps**: bump clouddrove/github-shared-workflows from 1.2.1 to 1.2.2 *(commit by [@dependabot[bot]](https://github.com/apps/dependabot))*


## [1.0.6] - 2023-05-05
### :sparkles: New Features
- [`4acc38c`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/4acc38c0f994e74f2baf2363e17169a83ff8433d) - auto changelog action added *(commit by [@anmolnagpal](https://github.com/anmolnagpal))*
- [`c889dc1`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/c889dc19ef17c34fccfefe8311570067bd6bd65d) - added dependabot.yml file *(commit by [@themaheshyadav](https://github.com/themaheshyadav))*

### :bug: Bug Fixes
- [`86bfda7`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/86bfda7ac4ce9a178cba0f3ff474bf57c4b99a59) - checkout action for workflow with github token *(commit by [@nileshgadgi](https://github.com/nileshgadgi))*


## [1.0.5] - 2023-04-13
### :bug: Bug Fixes
- [`28165db`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/28165db28e0687d0d56e78fa119201f1e67106d4) - Map type added for virtual machine extension and changed naming for all resources

## [1.0.4] - 2023-03-28
### :bug: Bug Fixes
- [`743e12f`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/743e12f4e58923e198d9ec224e15459b136d12ea) - changed format of disk encryption set and assigned id to key vault key

## [1.0.3] - 2023-03-21
### :bug: Bug Fixes
- [`26e4890`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/26e4890e47d60cd6ba49e62cc6398228a357d4ce) - set disk encryption set id to os disk of vm

## [1.0.2] - 2023-02-14
### :sparkles: New Features
- [`0baa7cc`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/0baa7ccd9b6243bbcd910894aae28f1771cbd303) - Added disk encryption added with cmk and host encryption Argument 

## [1.0.1] - 2023-01-24
### :sparkles: New Features
- [`60ba9cd`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/60ba9cd773b151534288505a7a1044ff14ceb986) - Added the windows virtual machine module

## [1.0.0] - 2023-01-09
### :sparkles: New Features
- [`e2f5a23`](https://github.com/clouddrove/terraform-azure-virtual-machine/commit/e2f5a23ff7b3cfb2ef7d9cdcae9dace9e0e21135) - Added Terraform Azure Virtual Machine Module.



[1.0.0]: https://github.com/clouddrove/terraform-azure-virtual-machine/compare/1.0.0...master
[1.0.1]: https://github.com/clouddrove/terraform-azure-virtual-machine/compare/1.0.0...1.0.1
[1.0.2]: https://github.com/clouddrove/terraform-azure-virtual-machine/compare/1.0.1...1.0.2
[1.0.3]: https://github.com/clouddrove/terraform-azure-virtual-machine/compare/1.0.3...1.0.4
[1.0.4]: https://github.com/clouddrove/terraform-azure-virtual-machine/compare/1.0.3...1.0.4
[1.0.5]: https://github.com/clouddrove/terraform-azure-virtual-machine/compare/1.0.4...1.0.5

[1.0.6]: https://github.com/clouddrove/terraform-azure-virtual-machine/compare/1.0.5...1.0.6
[2.0.0]: https://github.com/clouddrove/terraform-azure-virtual-machine/compare/1.0.3...2.0.0