# SWE-agent Model Compatibility Guide

This document provides a comprehensive guide to using different language models with SWE-agent.

## Overview

SWE-agent is a universal CLI agent that is **fully compatible with OpenAI API endpoints** and supports a wide range of language models through [LiteLLM](https://docs.litellm.ai/). This includes cloud-based models (OpenAI, Anthropic, DeepSeek) and local models (Ollama).

## Key Features

- ✅ **OpenAI API Compatible**: Works with any OpenAI-compatible API endpoint
- ✅ **Vision Model Support**: Native support for multimodal models that can process images
- ✅ **Local Model Support**: Run models locally with Ollama
- ✅ **100+ Providers**: Support for Azure, Google Cloud, AWS Bedrock, and more
- ✅ **Cost Control**: Built-in cost tracking and limits
- ✅ **Function Calling**: Support for structured tool use with compatible models

## Supported Models

### OpenAI

**Text Models:**
- `gpt-4o` - Latest flagship model with vision support
- `gpt-4o-mini` - Faster, more cost-effective with vision support
- `gpt-4-turbo` - Previous generation with vision support
- `gpt-4` - Standard GPT-4

**Setup:**
```bash
export OPENAI_API_KEY=your_api_key_here
```

**Example:**
```bash
sweagent run --config config/default.yaml --agent.model.name "gpt-4o" \
  --env.repo.github_url https://github.com/user/repo \
  --problem_statement.github_url https://github.com/user/repo/issues/1
```

### Anthropic Claude

**Models:**
- `claude-3-7-sonnet-20250219` - Current SOTA on SWE-bench with vision support
- `claude-3-5-sonnet-20241022` - Previous version with vision support
- `claude-3-opus-20240229` - Largest model with vision support
- `claude-3-sonnet-20240229` - Balanced model with vision support

**Setup:**
```bash
export ANTHROPIC_API_KEY=your_api_key_here
```

**Example:**
```bash
sweagent run --config config/default.yaml \
  --agent.model.name "claude-3-7-sonnet-20250219" \
  --env.repo.path /path/to/repo \
  --problem_statement.path /path/to/problem.md
```

### DeepSeek

**Models:**
- `deepseek-chat` - General purpose chat model
- `deepseek-coder` - Specialized for coding tasks
- `deepseek-vl` - Vision-language model

**Setup:**
```bash
export DEEPSEEK_API_KEY=your_api_key_here
```

**Example:**
```bash
sweagent run --config config/examples/deepseek.yaml \
  --env.repo.path /path/to/repo \
  --problem_statement.path /path/to/problem.md
```

### Ollama (Local Models)

**Text Models:**
- `ollama/llama3.3:70b` - Latest Llama model
- `ollama/codellama` - Specialized for code
- `ollama/deepseek-coder-v2` - Local DeepSeek coding model
- `ollama/qwen2.5-coder` - Qwen coding model

**Vision Models:**
- `ollama/llava` - LLaVA vision model
- `ollama/llava-phi3` - Efficient vision model
- `ollama/bakllava` - Another vision model variant

**Setup:**
1. Install Ollama from https://ollama.ai/
2. Pull a model: `ollama pull llama3.3:70b`
3. Ensure Ollama is running (default port: 11434)

**Example:**
```bash
sweagent run --config config/examples/ollama.yaml \
  --env.repo.path /path/to/repo \
  --problem_statement.path /path/to/problem.md
```

## Vision Model Support

SWE-agent natively supports multimodal models that can process both text and images.

### When to Use Vision Models

Vision models are useful for:
- Analyzing UI/UX issues with screenshots
- Understanding diagrams and architectural drawings
- Processing visual bug reports
- Debugging visual rendering issues
- Analyzing charts, graphs, and data visualizations

### Supported Vision Models

| Provider | Model | Notes |
|----------|-------|-------|
| OpenAI | `gpt-4o`, `gpt-4o-mini` | Best overall performance |
| Anthropic | `claude-3-*` (all variants) | Excellent for detailed analysis |
| DeepSeek | `deepseek-vl` | Cost-effective option |
| Ollama | `llava`, `llava-phi3`, `bakllava` | Free, local option |

### Using Vision Models

Vision models work out of the box - just specify a vision-capable model:

```bash
sweagent run --config config/examples/vision_model.yaml \
  --agent.model.name "gpt-4o" \
  --env.repo.path /path/to/repo \
  --problem_statement.path /path/to/problem.md
```

### Vision Message Format

The content field in messages can contain both text and image data:

```python
{
    "role": "user",
    "content": [
        {"type": "text", "text": "What's in this image?"},
        {"type": "image_url", "image_url": {"url": "https://example.com/image.jpg"}}
    ]
}
```

Images can be provided as:
- URLs: `https://example.com/image.jpg`
- Base64-encoded data: `data:image/jpeg;base64,/9j/4AAQ...`

## Advanced Configuration

### Custom API Endpoints

Use any OpenAI-compatible API endpoint:

```bash
sweagent run --config config/default.yaml \
  --agent.model.name "custom-model" \
  --agent.model.api_base "https://your-api-endpoint.com/v1" \
  --agent.model.api_key "your_api_key" \
  --env.repo.path /path/to/repo \
  --problem_statement.path /path/to/problem.md
```

### Cost Limits

Control costs with built-in limits:

```yaml
agent:
  model:
    per_instance_cost_limit: 3.0  # Limit per task ($)
    total_cost_limit: 100.0       # Total limit across all tasks ($)
```

### Context Window Configuration

Override default token limits:

```yaml
agent:
  model:
    max_input_tokens: 128000   # Override max input tokens
    max_output_tokens: 4096    # Override max output tokens
```

### Multiple API Keys (Load Balancing)

Rotate between multiple API keys:

```yaml
agent:
  model:
    api_key: key1:::key2:::key3  # Separate keys with :::
```

### Temperature and Sampling

Control model randomness:

```yaml
agent:
  model:
    temperature: 0.0  # Deterministic (recommended for coding)
    top_p: 1.0        # Nucleus sampling parameter
```

## Additional Providers

Through LiteLLM, SWE-agent supports 100+ model providers:

### Azure OpenAI
```bash
sweagent run --config config/default.yaml \
  --agent.model.name "azure/gpt-4o" \
  --agent.model.api_base "https://your-resource.openai.azure.com" \
  --agent.model.api_version "2024-02-01" \
  --env.repo.path /path/to/repo
```

### Google Vertex AI
```bash
sweagent run --config config/default.yaml \
  --agent.model.name "vertex_ai/gemini-pro" \
  --env.repo.path /path/to/repo
```

### AWS Bedrock
```bash
sweagent run --config config/default.yaml \
  --agent.model.name "bedrock/anthropic.claude-3-sonnet-20240229-v1:0" \
  --env.repo.path /path/to/repo
```

### Hugging Face
```bash
sweagent run --config config/default.yaml \
  --agent.model.name "huggingface/meta-llama/Llama-3.1-70B-Instruct" \
  --env.repo.path /path/to/repo
```

For full list of supported providers, see: https://docs.litellm.ai/docs/providers

## Environment Variables

### Recommended Setup

Create a `.env` file in your project root:

```bash
# .env
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
DEEPSEEK_API_KEY=sk-...

# Optional: For other providers
AZURE_API_KEY=...
VERTEX_PROJECT_ID=...
AWS_ACCESS_KEY_ID=...
```

### Using Environment Variables

SWE-agent automatically loads environment variables from `.env` files:

```bash
# API key is automatically detected from .env
sweagent run --config config/default.yaml \
  --agent.model.name "gpt-4o" \
  --env.repo.path /path/to/repo
```

## Function Calling Support

SWE-agent supports function calling for structured tool use with compatible models.

### Supported Models

Function calling is supported by:
- OpenAI: All GPT-4 and GPT-3.5-turbo models
- Anthropic: All Claude 3+ models
- DeepSeek: deepseek-chat, deepseek-coder
- Ollama: Some models (depends on the specific model)

### Configuration

Enable function calling in your config:

```yaml
agent:
  tools:
    parse_function:
      type: function_calling  # Use function calling
    # type: thought_action    # Fallback for models without function calling
```

## Troubleshooting

### "Model not found" error

**Problem:** API returns a model not found error.

**Solutions:**
- Verify the model name is spelled correctly
- Check that you have access to the model
- Ensure your API key has permission to use the model

### "API key not found" error

**Problem:** No API key found for the provider.

**Solutions:**
- Set environment variable: `export PROVIDER_API_KEY=your_key`
- Add to `.env` file
- Specify directly in config: `api_key: your_key`

### "Context window exceeded" error

**Problem:** Input tokens exceed the model's context window.

**Solutions:**
- Use a model with larger context window
- Reduce history: Adjust `history_processors` in config
- Set custom token limits: `max_input_tokens: 128000`

### Function calling not supported

**Problem:** Model doesn't support function calling.

**Solutions:**
- Use a model that supports function calling (GPT-4, Claude 3+)
- Switch to thought-action parsing: `parse_function: type: thought_action`
- See FAQ: https://swe-agent.com/latest/faq/

### Ollama connection refused

**Problem:** Cannot connect to Ollama.

**Solutions:**
- Ensure Ollama is running: `ollama serve`
- Check Ollama is on default port: `http://localhost:11434`
- Verify model is pulled: `ollama list`

## Performance Tips

### Choose the Right Model

For coding tasks:
- **Best overall**: `gpt-4o`, `claude-3-7-sonnet-20250219`
- **Cost-effective**: `gpt-4o-mini`, `deepseek-coder`
- **Local/free**: `ollama/llama3.3:70b`, `ollama/deepseek-coder-v2`

For vision tasks:
- **Best quality**: `gpt-4o`, `claude-3-7-sonnet-20250219`
- **Cost-effective**: `gpt-4o-mini`, `deepseek-vl`
- **Local/free**: `ollama/llava`

### Optimize Costs

1. Use cost limits:
   ```yaml
   per_instance_cost_limit: 3.0
   total_cost_limit: 100.0
   ```

2. Use cheaper models for simpler tasks:
   - Initial exploration: `gpt-4o-mini`
   - Complex fixes: `gpt-4o`

3. Use local models for development:
   - Ollama models are free to run
   - Good for testing and iteration

### Improve Quality

1. Use temperature 0 for deterministic results:
   ```yaml
   temperature: 0.0
   ```

2. Use demonstrations for better performance:
   ```yaml
   demonstrations:
     - path/to/demo.traj
   ```

3. Adjust history length:
   ```yaml
   history_processors:
     - type: last_n_observations
       n: 10  # Keep more context
   ```

## Examples

See `config/examples/` for complete configuration examples:
- `deepseek.yaml` - DeepSeek configuration
- `ollama.yaml` - Ollama local models configuration
- `vision_model.yaml` - Vision model configuration

## References

- [LiteLLM Documentation](https://docs.litellm.ai/)
- [OpenAI API Reference](https://platform.openai.com/docs/api-reference)
- [Anthropic API Reference](https://docs.anthropic.com/claude/reference)
- [DeepSeek API Reference](https://platform.deepseek.com/api-docs/)
- [Ollama Documentation](https://github.com/ollama/ollama)
- [SWE-agent FAQ](https://swe-agent.com/latest/faq/)
