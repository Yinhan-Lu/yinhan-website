#!/bin/bash
# 部署网站脚本

echo "🚀 开始部署流程..."
echo ""

# 检查是否有未提交的更改
if [[ -n $(git status -s) ]]; then
    echo "📝 发现未提交的更改："
    git status -s
    echo ""

    # 询问提交信息
    echo "💬 请输入提交信息 (按 Enter 使用默认信息):"
    read -r commit_message

    if [ -z "$commit_message" ]; then
        commit_message="更新网站内容 - $(date '+%Y-%m-%d %H:%M')"
    fi

    echo ""
    echo "📦 提交更改..."
    git add .
    git commit -m "$commit_message"
else
    echo "✅ 没有新的更改需要提交"
fi

echo ""
echo "📤 推送到 GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 部署成功！"
    echo ""
    echo "🔗 查看部署状态: https://github.com/Yinhan-Lu/yinhan-website/actions"
    echo "🌐 网站地址: https://yinhanlu.me"
    echo ""
    echo "⏰ 部署通常需要 5-10 分钟完成"
else
    echo ""
    echo "❌ 推送失败，请检查错误信息"
    exit 1
fi
