# Contributing to Unraid Plugin Documentation

<a href="https://github.com/mstrhakr/unraid-plugin-docs"><img src="assets/images/logos/GitHub%20Logos/GitHub_Lockup_White.svg" alt="GitHub" height="40" align="right"></a>

Thank you for your interest in contributing! This documentation is a community effort, and we welcome all contributions.

## Ways to Contribute

### Report Issues

Found an error or something unclear? [Open an issue](../../issues) with:
- A clear description of the problem
- The page/section affected
- Suggested correction (if you have one)

### Submit Documentation

Have knowledge to share? Pull requests are welcome:

1. Fork the repository
2. Create a feature branch (`git checkout -b docs/new-section`)
3. Make your changes
4. Submit a pull request

### Review and Feedback

- Review open pull requests
- Test documentation against real plugins
- Suggest improvements in discussions

## Documentation Guidelines

### Writing Style

- **Be concise**: Plugin developers are busy
- **Use examples**: Code speaks louder than words
- **Be accurate**: Test commands and code before documenting
- **Stay current**: Note version requirements when relevant

### Formatting

- Use proper Markdown formatting
- Include code blocks with language hints:
  ```php
  <?php
  // PHP code here
  ?>
  ```
- Use tables for reference information
- Include diagrams for complex concepts (ASCII art is fine)

### Structure

Each documentation page should have:

1. **Title** - Clear H1 header
2. **Introduction** - Brief overview of the topic
3. **Content** - Main documentation
4. **Examples** - Practical code examples
5. **Next Steps** - Links to related topics

### File Organization

```
docs/
├── introduction.md      # Getting started
├── plg-file.md          # PLG file reference
├── page-files.md        # Page file reference
├── events.md            # Event system
├── filesystem.md        # File locations
├── [topic].md           # Other topics
```

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help newcomers learn
- Give credit where due

## Questions?

- Open a [discussion](../../discussions) for questions
- Check existing issues before creating new ones
- Tag maintainers if you need help

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (CC BY-SA 4.0 for documentation, MIT for code examples).
