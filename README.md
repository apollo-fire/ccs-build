# ccs_build
Docker Action that can build a Code Composer Studio project

## Example usage
```yaml
- uses: apollo-fire/ccs-build@v0.0.5
  with:
    build-configuration: Debug
```

## Selecting a Specific Compiler
```yaml
- uses: apollo-fire/ccs-build/compiler/<compiler version>@v0.0.5
  with:
    build-configuration: Debug

# Using 21.6.0 as a worked example:
- uses: apollo-fire/ccs-build/compiler/21.6.0@v0.0.5
  with:
    build-configuration: Debug    
```

### Available MSP430 Compilers
* 18.1.3
* 21.6.0
