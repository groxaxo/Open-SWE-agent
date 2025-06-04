<p align="center">
  <a href="https://swe-agent.com/latest/">
    <img src="assets/swe-agent-banner.png" alt="swe-agent.com" style="height: 12em" />
  </a>
</p>

<p align="center">
  <a href="https://swe-agent.com/latest/"><strong>Documentation</strong></a>&nbsp; | &nbsp;
  <a href="https://discord.gg/AVEFbBn2rH"><strong>Discord</strong></a>&nbsp; | &nbsp;
  <a href="https://arxiv.org/abs/2405.15793"><strong>Paper</strong></a>
</p>


SWE-agent lets your language model of choice (e.g. GPT-4o or Claude Sonnet 3.7) autonomously use tools to:

* [fix issues in real GitHub repositories](https://swe-agent.com/latest/usage/hello_world),
* perform tasks on the web,
* [find cybersecurity vulnerabilities](https://enigma-agent.com/) (by solving Capture The Flag challenges), or
* [any custom task](https://swe-agent.com/latest/usage/coding_challenges).

It does so by using configurable [agent-computer interfaces](https://arxiv.org/abs/2405.15793) (ACIs) to interact with isolated computer environments.

SWE-agent is built and maintained by researchers from Princeton University and Stanford University.

## 💪 Key Capabilities

SWE-agent provides several powerful capabilities:

- **Isolated Environments**: Run agents in Docker containers to ensure safety and reproducibility
- **Multiple Model Support**: Use GPT-4, Claude, or any LiteLLM-supported model
- **Tool Use**: Provide agents with a configurable set of tools to interact with the environment
- **Function Calling**: Structured tool use with modern LLMs that support function calling
- **Cost Control**: Set limits on API costs to prevent unexpected expenses
- **Benchmarking**: Run agents on multiple tasks and evaluate their performance
- **Human-in-the-Loop**: Interact with the agent during execution for debugging or assistance
- **Extensibility**: Add custom models, tools, environments, and hooks

## 📣 News

* May 2: [SWE-agent-LM-32b](https://swesmith.com) achieves open-weights SOTA on SWE-bench
* Feb 28: [SWE-agent 1.0 + Claude 3.7 is SoTA on SWE-Bench full](https://x.com/KLieret/status/1895487966409298067)
* Feb 25: [SWE-agent 1.0 + Claude 3.7 is SoTA on SWE-bench verified](https://x.com/KLieret/status/1894408819670733158)
* Feb 13: [Releasing SWE-agent 1.0: SoTA on SWE-bench light & tons of new features](https://x.com/KLieret/status/1890048205448220849)
* Dec 7: [An interview with the SWE-agent & SWE-bench team](https://www.youtube.com/watch?v=fcr8WzeEXyk)

## 🚀 Get started!

👉 Try SWE-agent in your browser: [![Open in GitHub Codespaces](https://img.shields.io/badge/Open_in_GitHub_Codespaces-gray?logo=github)](https://codespaces.new/SWE-agent/SWE-agent) ([more information](https://swe-agent.com/latest/installation/codespaces/))

### Quick Installation

For local installation, we provide easy-to-use installation scripts:

```bash
# Clone the repository
git clone https://github.com/SWE-agent/SWE-agent.git
cd SWE-agent

# Run the installation script
./install.sh  # Basic installation
# OR
./install_advanced.sh  # Advanced installation with more options
```

See [INSTALL.md](INSTALL.md) for detailed installation instructions.

### Learn More

Read our [documentation][docs] to learn more:

* [Installation](https://swe-agent.com/latest/installation/source/)
* [Hello world from the command line](https://swe-agent.com/latest/usage/hello_world/)
* [Benchmarking on SWE-bench](https://swe-agent.com/latest/usage/batch_mode/)
* [Frequently Asked Questions](https://swe-agent.com/latest/faq/)

[docs]: https://swe-agent.com

## 🏗️ Codebase Structure

SWE-agent is organized into several key modules:

### Core Components

- **Agent Module** (`sweagent/agent/`): Implements the agent logic and interaction with language models
  - `agents.py`: Contains the `DefaultAgent` class that manages the agent's execution flow
  - `models.py`: Handles different model backends (GPT, Claude, human-in-the-loop, etc.)
  - `problem_statement.py`: Manages the problem descriptions that the agent works on

- **Environment Module** (`sweagent/environment/`): Manages the execution environment
  - `swe_env.py`: Contains the `SWEEnv` class that provides an isolated environment (typically Docker containers)
  - Handles file system operations, command execution, and environment setup

- **Tools Module** (`sweagent/tools/`): Implements the tools available to the agent
  - `tools.py`: Contains the `ToolHandler` class that manages available commands
  - Handles command parsing, execution, and filtering

- **Run Module** (`sweagent/run/`): Contains the CLI interface and execution logic
  - `run_single.py`: Handles running a single agent instance
  - `run_batch.py`: Manages batch execution for benchmarking

### Execution Flow

1. The user provides a problem statement (GitHub issue, local file, etc.)
2. SWE-agent sets up an isolated environment (Docker container)
3. The agent iteratively:
   - Analyzes the problem and context
   - Decides on actions to take
   - Executes commands through the environment
   - Observes results and updates its understanding
4. The agent continues until it solves the problem or reaches a stopping condition

### Configuration

SWE-agent is highly configurable through YAML files and command-line arguments:
- Model selection and parameters
- Environment settings
- Tool availability and permissions
- Execution hooks for custom behaviors

### Extending SWE-agent

SWE-agent is designed to be extensible in several ways:

1. **Custom Models**: Add support for new language models by extending the `AbstractModel` class
   - Implement the `query` method to interact with your model
   - Register your model in the `get_model` factory function

2. **Custom Tools**: Add new tools by defining them in your configuration
   - Tools are defined as commands with optional parameters
   - Function calling is supported for structured tool use

3. **Custom Environments**: Create specialized environments by extending the `SWEEnv` class
   - Implement custom deployment types beyond Docker
   - Add specialized file system or network capabilities

4. **Custom Hooks**: Add hooks to modify agent behavior at different stages
   - Implement the `RunHook` interface to add custom behaviors
   - Hooks can be triggered at initialization, start, completion, etc.

## 🔧 Advanced Usage Examples

### Fixing a GitHub Issue

```bash
sweagent run --config config/default.yaml --agent.model.name "gpt-4o" \
    --env.repo.github_url=https://github.com/SWE-agent/test-repo/ \
    --problem_statement.github_url=https://github.com/SWE-agent/test-repo/issues/1
```

### Using a Local Repository

```bash
sweagent run --config config/default.yaml --agent.model.name "gpt-4o" \
    --env.repo.path /path/to/local/repo \
    --problem_statement.path /path/to/problem_statement.md
```

### Running with Human-in-the-Loop

```bash
sweagent run --config config/default.yaml --agent.model.name "human" \
    --env.repo.github_url=https://github.com/SWE-agent/test-repo/ \
    --problem_statement.github_url=https://github.com/SWE-agent/test-repo/issues/1
```

### Benchmarking on Multiple Tasks

```bash
sweagent run-batch --config config/default.yaml --agent.model.name "gpt-4o" \
    --env.repo.github_url=https://github.com/SWE-agent/test-repo/ \
    --problem_statement.path /path/to/problem_statements/
```

## SWE-agent for offensive cybersecurity (EnIGMA) <a name="enigma"></a>

<img src="https://github.com/user-attachments/assets/84599168-11a7-4776-8a49-33dbf0758bb2" height="80px"></img>

[SWE-agent: EnIGMA][enigma] is a mode for solving offensive cybersecurity (capture the flag) challenges.
EnIGMA achieves state-of-the-art results on multiple cybersecurity benchmarks (see [leaderboard](https://enigma-agent.com/#results)).
Please use [SWE-agent 0.7](https://github.com/SWE-agent/SWE-agent/tree/v0.7) while we update EnIGMA for 1.0.

[enigma]: https://enigma-agent.com
[SWE-bench]: https://github.com/SWE-bench/SWE-bench
[nyu-ctf]: https://arxiv.org/abs/2406.05590

In addition, you might be interested in the following projects:


<div align="center">
  <a href="https://github.com/SWE-agent/SWE-ReX"><img src="docs/assets/swerex_logo_text_below.svg" alt="SWE-ReX" height="120px"></a>
   &nbsp;&nbsp;
  <a href="https://github.com/SWE-bench/SWE-bench"><img src="docs/assets/swebench_logo_text_below.svg" alt="SWE-bench" height="120px"></a>
  &nbsp;&nbsp;
  <!-- <a href="https://github.com/SWE-agent/SWE-agent"><img src="docs/assets/sweagent_logo_text_below.svg" alt="SWE-agent" height="120px"></a> -->
  <a href="https://github.com/SWE-bench/SWE-smith"><img src="docs/assets/swesmith_logo_text_below.svg" alt="SWE-smith" height="120px"></a>
  &nbsp;&nbsp;
  <a href="https://github.com/SWE-bench/sb-cli"><img src="docs/assets/sbcli_logo_text_below.svg" alt="sb-cli" height="120px"></a>
</div>

## Contributions <a name="contributions"></a>

If you'd like to contribute to the codebase, we welcome [issues](https://github.com/SWE-agent/SWE-agent/issues) and [pull requests](https://github.com/SWE-agent/SWE-agent/pulls)! For larger code changes, we always encourage discussion in issues first.

### Development Setup

#### Automated Installation (Recommended)

We provide two installation scripts for easy setup:

1. Basic installation:
   ```bash
   ./install.sh
   ```
   This script automatically creates a virtual environment using uv or conda (whichever is available) and installs all required dependencies.

2. Advanced installation with more options:
   ```bash
   ./install_advanced.sh
   ```
   This script provides additional options like Python version selection, system dependency checks, and more.

See [INSTALL.md](INSTALL.md) for detailed installation instructions.

#### Manual Installation

If you prefer to install manually:

1. Clone the repository:
   ```bash
   git clone https://github.com/SWE-agent/SWE-agent.git
   cd SWE-agent
   ```

2. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -e ".[dev]"
   ```

4. Run tests:
   ```bash
   pytest
   ```

### Code Structure for Contributors

- **Core Logic**: Most of the agent's core logic is in `sweagent/agent/agents.py`
- **Model Interaction**: Model interfaces are defined in `sweagent/agent/models.py`
- **Environment**: Environment setup and interaction in `sweagent/environment/swe_env.py`
- **Tools**: Tool definitions and handling in `sweagent/tools/tools.py`
- **CLI**: Command-line interface in `sweagent/run/`

## Citation & contact <a name="citation"></a>

SWE-agent is an academic project started at Princeton University by John Yang*, Carlos E. Jimenez*, Alexander Wettig, Kilian Lieret, Shunyu Yao, Karthik Narasimhan, and Ofir Press.
Contact person: [John Yang](https://john-b-yang.github.io/), [Carlos E. Jimenez](http://www.carlosejimenez.com/), and [Kilian Lieret](https://www.lieret.net/) (Email: johnby@stanford.edu, carlosej@princeton.edu, kl5675@princeton.edu).

If you found this work helpful, please consider citing it using the following:

<details>
<summary> SWE-agent citation</summary>

```bibtex
@inproceedings{yang2024sweagent,
  title={{SWE}-agent: Agent-Computer Interfaces Enable Automated Software Engineering},
  author={John Yang and Carlos E Jimenez and Alexander Wettig and Kilian Lieret and Shunyu Yao and Karthik R Narasimhan and Ofir Press},
  booktitle={The Thirty-eighth Annual Conference on Neural Information Processing Systems},
  year={2024},
  url={https://arxiv.org/abs/2405.15793}
}
```
</details>

If you used the summarizer, interactive commands or the offensive cybersecurity capabilities in SWE-agent, please also consider citing:

<details>
<summary>EnIGMA citation</summary>

```bibtex
@misc{abramovich2024enigmaenhancedinteractivegenerative,
      title={EnIGMA: Enhanced Interactive Generative Model Agent for CTF Challenges},
      author={Talor Abramovich and Meet Udeshi and Minghao Shao and Kilian Lieret and Haoran Xi and Kimberly Milner and Sofija Jancheska and John Yang and Carlos E. Jimenez and Farshad Khorrami and Prashanth Krishnamurthy and Brendan Dolan-Gavitt and Muhammad Shafique and Karthik Narasimhan and Ramesh Karri and Ofir Press},
      year={2024},
      eprint={2409.16165},
      archivePrefix={arXiv},
      primaryClass={cs.AI},
      url={https://arxiv.org/abs/2409.16165},
}
```
</details>


## 🪪 License <a name="license"></a>
MIT. Check `LICENSE`.


<div align="center">

[![Pytest](https://github.com/SWE-agent/SWE-agent/actions/workflows/pytest.yaml/badge.svg)](https://github.com/SWE-agent/SWE-agent/actions/workflows/pytest.yaml)
[![build-docs](https://github.com/SWE-agent/SWE-agent/actions/workflows/build-docs.yaml/badge.svg)](https://github.com/SWE-agent/SWE-agent/actions/workflows/build-docs.yaml)
[![codecov](https://codecov.io/gh/SWE-agent/SWE-agent/graph/badge.svg?token=18XAVDK365)](https://codecov.io/gh/SWE-agent/SWE-agent)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/SWE-agent/SWE-agent/main.svg)](https://results.pre-commit.ci/latest/github/SWE-agent/SWE-agent/main)
[![Markdown links](https://github.com/SWE-agent/SWE-agent/actions/workflows/check-links.yaml/badge.svg)](https://github.com/SWE-agent/SWE-agent/actions/workflows/check-links.yaml)

</div>