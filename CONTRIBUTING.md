# Contributing to Shoperzz

We welcome contributions to Shoperzz! Here are some guidelines to help you get started.

## How Can I Contribute?

### Reporting Bugs

* **Ensure the bug hasn't already been reported.** Search through existing issues to see if someone else has already reported it.
* **Provide a clear and concise description of the issue.** Explain the problem and how to reproduce it.
* **Include relevant details.** This could include your operating system, browser, Shoperzz version, and any error messages.

### Suggesting Enhancements

* **Check existing suggestions.** See if your idea has already been proposed.
* **Clearly describe the enhancement.** Explain what you want to achieve and why it would be beneficial.
* **Provide examples or mockups if possible.** This helps us understand your vision.

### Code Contributions

* **Fork the repository.**
* **Create a new branch** for your feature or bug fix.
* **Write clear, concise, and well-documented code.** Follow the existing coding style.
* **Write tests** for your changes to ensure they work as expected and prevent regressions.
* **Submit a Pull Request (PR).**
  * **Provide a descriptive title and summary** of your changes.
  * **Reference any related issues** (e.g., "Fixes #123").
  * **Ensure your code passes all tests and linting checks.**

## Development Setup

1. **Clone the repository**: `git clone https://github.com/shoperzz/shoperzz.git`
2. **Install pnpm**: If you don't have it, run `npm install -g pnpm`.
3. **Install dependencies**: `pnpm install` from the root.
4. **Run in development**: `pnpm dev` to start all packages and apps via Turborepo.
5. **Build**: `pnpm build` to build all packages.

## Code Style

We use **Prettier** for formatting and **ESLint** for linting.
* Run `pnpm format` to format the entire codebase.
* Run `pnpm lint` to check for linting errors.
* Strict **TypeScript** is enforced across all packages.

## Licensing

By contributing to Shoperzz, you agree that your contributions will be licensed under its [LICENSE](LICENSE) file.

Thank you for contributing to Shoperzz!
