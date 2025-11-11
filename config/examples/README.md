# SWE-agent Model Configuration Examples

This directory contains example configurations for using SWE-agent with different model providers.

## Quick Start

### OpenAI (GPT-4o)
```bash
# Set your API key
export OPENAI_API_KEY=your_key_here

# Run with default config
sweagent run --config config/default.yaml --agent.model.name "gpt-4o" \
  --env.repo.path /path/to/repo \
  --problem_statement.path /path/to/problem.md
```

### DeepSeek
```bash
# Set your API key
export DEEPSEEK_API_KEY=your_key_here

# Run with DeepSeek config
sweagent run --config config/examples/deepseek.yaml \
  --env.repo.path /path/to/repo \
  --problem_statement.path /path/to/problem.md
```

### Ollama (Local Models)
```bash
# First, install Ollama and pull a model
# Download from https://ollama.ai/
ollama pull llama3.3:70b

# Run with Ollama config
sweagent run --config config/examples/ollama.yaml \
  --env.repo.path /path/to/repo \
  --problem_statement.path /path/to/problem.md
```

### Vision Models
```bash
# Vision models work with the same API key setup
# Supported models: gpt-4o, claude-3-sonnet, deepseek-vl, ollama/llava

sweagent run --config config/examples/vision_model.yaml \
  --agent.model.name "gpt-4o" \
  --env.repo.path /path/to/repo \
  --problem_statement.path /path/to/problem.md
```

## Available Configurations

### `deepseek.yaml`
Configuration for using DeepSeek models:
- `deepseek-chat`: General purpose chat model
- `deepseek-coder`: Specialized for coding tasks
- `deepseek-vl`: Vision-language model

**Setup:**
```bash
export DEEPSEEK_API_KEY=your_key_here
```

### `ollama.yaml`
Configuration for running models locally with Ollama:
- Text models: `llama3.3:70b`, `codellama`, `deepseek-coder-v2`, `qwen2.5-coder`
- Vision models: `llava`, `llava-phi3`, `bakllava`

**Setup:**
1. Install Ollama: https://ollama.ai/
2. Pull a model: `ollama pull llama3.3:70b`
3. Ensure Ollama is running (default port: 11434)

### `vision_model.yaml`
Configuration optimized for vision-capable models that can process images:
- OpenAI: `gpt-4o`, `gpt-4o-mini`
- Anthropic: `claude-3-opus`, `claude-3-sonnet`, `claude-3-7-sonnet-20250219`
- DeepSeek: `deepseek-vl`
- Ollama: `ollama/llava`, `ollama/llava-phi3`

Vision models are useful for:
- Analyzing UI/UX issues with screenshots
- Understanding diagrams and architectural drawings
- Processing visual bug reports
- Debugging visual rendering issues

## Model Provider Details

### OpenAI
- **Models**: `gpt-4o`, `gpt-4o-mini`, `gpt-4-turbo`, `gpt-4`
- **Vision Support**: ✅ (gpt-4o, gpt-4o-mini)
- **Setup**: `export OPENAI_API_KEY=your_key`
- **Docs**: https://platform.openai.com/docs/

### Anthropic Claude
- **Models**: `claude-3-7-sonnet-20250219`, `claude-3-5-sonnet-20241022`, `claude-3-opus`
- **Vision Support**: ✅ (All Claude 3+ models)
- **Setup**: `export ANTHROPIC_API_KEY=your_key`
- **Docs**: https://docs.anthropic.com/

### DeepSeek
- **Models**: `deepseek-chat`, `deepseek-coder`, `deepseek-vl`
- **Vision Support**: ✅ (deepseek-vl)
- **Setup**: `export DEEPSEEK_API_KEY=your_key`
- **API Base**: `https://api.deepseek.com`
- **Docs**: https://platform.deepseek.com/

### Ollama (Local)
- **Text Models**: `llama3.3:70b`, `codellama`, `deepseek-coder-v2`, `qwen2.5-coder`
- **Vision Models**: `llava`, `llava-phi3`, `bakllava`
- **Vision Support**: ✅ (LLaVA models)
- **Setup**: Install from https://ollama.ai/
- **API Base**: `http://localhost:11434`
- **Docs**: https://github.com/ollama/ollama

## Advanced Configuration

### Custom API Endpoint
```yaml
agent:
  model:
    name: custom-model
    api_base: https://your-api-endpoint.com/v1
    api_key: your_api_key
    temperature: 0.0
```

### Cost Limits
```yaml
agent:
  model:
    per_instance_cost_limit: 3.0  # Limit per task
    total_cost_limit: 100.0       # Total limit across all tasks
```

### Context Window
```yaml
agent:
  model:
    max_input_tokens: 128000   # Override default input token limit
    max_output_tokens: 4096    # Override default output token limit
```

### Multiple API Keys (Load Balancing)
```yaml
agent:
  model:
    api_key: key1:::key2:::key3  # Rotate between keys
```

## Environment Variables

SWE-agent automatically loads environment variables from `.env` files. Create a `.env` file in your project root:

```bash
# .env file
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
DEEPSEEK_API_KEY=sk-...
```

## Additional Providers

Through LiteLLM, SWE-agent supports 100+ model providers. For full list, see:
https://docs.litellm.ai/docs/providers

Popular providers include:
- Azure OpenAI: `azure/<deployment_name>`
- Google Vertex AI: `vertex_ai/<model_name>`
- AWS Bedrock: `bedrock/<model_name>`
- Hugging Face: `huggingface/<model_name>`
- Cohere: `command-r`, `command-r-plus`
- Mistral: `mistral/<model_name>`

## Troubleshooting

### "Model not found" error
- Ensure you've set the correct API key for your provider
- Check that the model name is spelled correctly
- For Ollama, verify the model is pulled: `ollama list`

### "API key not found" error
- Set environment variable: `export PROVIDER_API_KEY=your_key`
- Or add to `.env` file
- Or specify directly in config: `api_key: your_key`

### Context window exceeded
- Reduce the history: Adjust `history_processors` in config
- Use a model with larger context window
- Set custom token limits in config

### Function calling not supported
- Some models don't support function calling
- Use `parse_function: type: thought_action` instead
- See FAQ: https://swe-agent.com/latest/faq/

## Examples

### Example 1: Fix a bug using DeepSeek
```bash
export DEEPSEEK_API_KEY=your_key

sweagent run --config config/examples/deepseek.yaml \
  --env.repo.github_url https://github.com/user/repo \
  --problem_statement.github_url https://github.com/user/repo/issues/123
```

### Example 2: Analyze UI bug with vision model
```bash
export OPENAI_API_KEY=your_key

sweagent run --config config/examples/vision_model.yaml \
  --agent.model.name "gpt-4o" \
  --env.repo.path /path/to/frontend/repo \
  --problem_statement.path bug_report_with_screenshots.md
```

### Example 3: Run locally with Ollama
```bash
ollama pull llama3.3:70b

sweagent run --config config/examples/ollama.yaml \
  --env.repo.path /path/to/repo \
  --problem_statement.path problem.md
```

## Contributing

Have a useful configuration? Submit a PR to add it to this directory!
