#!/bin/bash

echo "═══════════════════════════════════════════════════════"
echo "  Claude Code + Taskmaster Workflow Setup"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "Prerequisites:"
echo "✓ Claude Code installed"
echo "✓ npm/node installed"
echo "✓ Linear account (for team sync)"
echo "✓ API keys for: Anthropic, OpenAI, Perplexity"
echo ""
echo "Setup Steps:"
echo ""
echo "1. Install Taskmaster globally:"
echo "   npm install -g task-master-ai"
echo ""
echo "2. Copy MCP configuration:"
echo "   cp ~/.claude/mcp.json ~/.claude/mcp.json.backup (if exists)"
echo "   Then add the configuration from README.md"
echo ""
echo "3. Add your API keys to ~/.claude/mcp.json"
echo ""
echo "4. Connect Linear to Slack:"
echo "   https://linear.app/docs/slack"
echo ""
echo "5. Restart Claude Code"
echo ""
echo "6. Test the setup:"
echo "   /project:workflow-status"
echo ""
echo "For detailed instructions, see README.md"
echo ""
echo "Press Enter to open README.md in your default editor..."
read -r

# Open README in default editor
if command -v code >/dev/null 2>&1; then
    code README.md
elif command -v open >/dev/null 2>&1; then
    open README.md
else
    echo "README.md contains full setup instructions"
fi 