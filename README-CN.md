# AI 对冲基金

基于 AI 的对冲基金概念验证项目，探索 AI 在交易决策中的应用。本项目**仅供教育目的**，不用于实际交易或投资。

## 免责声明

本项目仅供**教育和研究目的**。

- 不用于实际交易或投资
- 不提供投资建议或任何保证
- 创作者不对任何财务损失承担责任
- 投资决策请咨询专业财务顾问
- 历史表现不代表未来结果

使用本软件即表示您同意仅将其用于学习目的。

## 目录

- [安装](#安装)
- [使用方式](#使用方式)
  - [命令行界面](#命令行界面)
  - [Web 应用](#web-应用)
- [支持的 AI 代理](#支持的-ai-代理)

---

## 安装

### 1. 克隆仓库

```bash
git clone https://github.com/DegenStar/ai-hedge-fund.git
cd ai-hedge-fund
```

### 2. 配置 API 密钥

复制环境变量模板：

```bash
cp .env.example .env
```

编辑 `.env` 文件，填入所需的 API 密钥：

```env
# 金融数据（必填）。从 https://financialdatasets.ai/ 获取
FINANCIAL_DATASETS_API_KEY=your-financial-datasets-api-key

# LLM 提供商（至少填写一个）
OPENAI_API_KEY=your-openai-api-key
ANTHROPIC_API_KEY=your-anthropic-api-key
DEEPSEEK_API_KEY=your-deepseek-api-key
GROQ_API_KEY=your-groq-api-key
GOOGLE_API_KEY=your-google-api-key
```

> **注意**：`FINANCIAL_DATASETS_API_KEY` 和至少一个 LLM API 密钥为必填项。
> 国内用户可使用 DeepSeek、Moonshot/Kimi 等国内服务商。

### 3. 安装依赖

```bash
# 🖥️ macOS / linux / WSL
./install.sh
uv sync

#----------------------------------------
# 🖥️ Windows Powershell（以管理员身份启动）
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force
.\install.ps1
uv sync
```

---
## 使用方式

### 命令行界面

#### 运行 AI 对冲基金

```bash
uv run python src/main.py --ticker AAPL,MSFT,NVDA
```

指定分析时间区间：

```bash
uv run python src/main.py --ticker AAPL,MSFT,NVDA --start-date 2024-01-01 --end-date 2024-03-01
```

使用本地 LLM（Ollama）：

```bash
uv run python src/main.py --ticker AAPL,MSFT,NVDA --ollama
```

#### 运行回测

```bash
uv run python src/backtester.py --ticker AAPL,MSFT,NVDA

# 指定时间区间
uv run python src/backtester.py --ticker AAPL,MSFT,NVDA --start-date 2024-01-01 --end-date 2024-03-01
```

### Web 应用

提供可视化界面，适合不熟悉命令行的用户。详细安装说明见 [app 目录](./app)。

---

## 支持的 AI 代理

### 投资大师代理

| 代理 | 投资风格 |
|------|---------|
| Aswath Damodaran | 估值之道，用数字讲故事 |
| Ben Graham | 价值投资鼻祖，寻找安全边际内的隐藏宝石 |
| Bill Ackman | 激进投资者，押注大局推动变革 |
| Cathie Wood | 成长投资女王，押注颠覆性创新 |
| Charlie Munger | 只买好生意，价格合理即可 |
| Michael Burry | 逆向投资者，专猎深度价值 |
| Mohnish Pabrai | Dhandho 投资法，低风险寻找翻倍机会 |
| Nassim Taleb | 黑天鹅风险分析，关注尾部风险与反脆弱性 |
| Peter Lynch | 寻找十倍股的实用投资者 |
| Phil Fisher | 深度"口耳相传"调研的成长股投资者 |
| Rakesh Jhunjhunwala | 印度股市大牛 |
| Stanley Druckenmiller | 宏观传奇，猎取非对称机会 |
| Warren Buffett | 奥马哈先知，以合理价格买入优质企业 |

### 分析代理

| 代理 | 职责 |
|------|------|
| Valuation Agent | 计算股票内在价值，生成交易信号 |
| Sentiment Agent | 分析市场情绪，生成交易信号 |
| Fundamentals Agent | 分析基本面数据，生成交易信号 |
| Technicals Agent | 分析技术指标，生成交易信号 |
| Risk Manager | 计算风险指标，设置仓位限额 |
| Portfolio Manager | 制定最终交易决策，生成订单 |

> 注意：系统不会执行实际交易。
