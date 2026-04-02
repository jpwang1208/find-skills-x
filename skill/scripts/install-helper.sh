#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${CYAN}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

detect_package_manager() {
    if command -v brew &> /dev/null; then echo "brew"
    elif command -v apt-get &> /dev/null; then echo "apt"
    elif command -v yum &> /dev/null; then echo "yum"
    else echo "none"
    fi
}

install_gh() {
    log_info "安装 GitHub CLI..."
    
    if command -v gh &> /dev/null; then
        log_success "GitHub CLI 已安装: $(gh --version | head -1)"
        return 0
    fi
    
    local pkg_mgr=$(detect_package_manager)
    
    case "$pkg_mgr" in
        brew)
            brew install gh
            ;;
        apt)
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update && sudo apt install gh
            ;;
        yum)
            sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
            sudo dnf install gh
            ;;
        *)
            log_error "无法自动安装，请手动安装: https://cli.github.com/manual/installation"
            return 1
            ;;
    esac
    
    if command -v gh &> /dev/null; then
        log_success "GitHub CLI 安装成功"
        return 0
    fi
    
    return 1
}

install_skills() {
    log_info "安装 skills CLI..."
    
    if command -v skills &> /dev/null; then
        log_success "skills CLI 已安装"
        return 0
    fi
    
    if npm install -g skills 2>/dev/null; then
        log_success "skills CLI 安装成功"
        return 0
    fi
    
    log_error "skills CLI 安装失败"
    return 1
}

install_skillhub() {
    log_info "安装腾讯 SkillHub CLI..."
    
    if command -v skillhub &> /dev/null; then
        log_success "SkillHub CLI 已安装"
        return 0
    fi
    
    local tmp_script="/tmp/skillhub-install-$$.sh"
    
    if curl -fsSL "https://skillhub-1388575217.cos.ap-guangzhou.myqcloud.com/install/install.sh" -o "$tmp_script" 2>/dev/null; then
        if bash "$tmp_script" --cli-only &>/dev/null; then
            rm -f "$tmp_script"
            log_success "SkillHub CLI 安装成功"
            return 0
        fi
        rm -f "$tmp_script"
    fi
    
    log_error "SkillHub CLI 安装失败，请访问: https://skillhub.tencent.com"
    return 1
}

login_github() {
    log_info "GitHub CLI 登录..."
    
    if ! command -v gh &> /dev/null; then
        log_error "请先安装 GitHub CLI"
        return 1
    fi
    
    if gh auth status &>/dev/null; then
        log_success "GitHub 已登录"
        return 0
    fi
    
    log_info "正在启动 GitHub 登录..."
    gh auth login
}

show_status() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📊 CLI 工具状态"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if command -v gh &> /dev/null; then
        local gh_auth=""
        if gh auth status &>/dev/null 2>&1; then
            gh_auth="${GREEN}已登录${NC}"
        else
            gh_auth="${YELLOW}未登录${NC}"
        fi
        echo -e "GitHub CLI:    ${GREEN}✓ 已安装${NC} | $gh_auth"
    else
        echo -e "GitHub CLI:    ${RED}✗ 未安装${NC}"
    fi
    
    if command -v skills &> /dev/null; then
        echo -e "skills CLI:    ${GREEN}✓ 已安装${NC}"
    else
        echo -e "skills CLI:    ${YELLOW}⚠ 未安装${NC} (可选)"
    fi
    
    if command -v skillhub &> /dev/null; then
        echo -e "SkillHub CLI:  ${GREEN}✓ 已安装${NC} (国内推荐)"
    else
        echo -e "SkillHub CLI:  ${YELLOW}⚠ 未安装${NC} (国内推荐)"
    fi
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

main() {
    local action="${1:-status}"
    
    case "$action" in
        status)
            show_status
            ;;
        all)
            log_info "安装所有 CLI 工具..."
            install_gh && login_github
            install_skillhub
            install_skills
            show_status
            ;;
        gh|github)
            install_gh
            ;;
        skillhub)
            install_skillhub
            ;;
        skills)
            install_skills
            ;;
        login)
            login_github
            ;;
        *)
            echo "用法: $0 [status|all|gh|skillhub|skills|login]"
            echo ""
            echo "命令:"
            echo "  status   - 显示 CLI 工具状态（默认）"
            echo "  all      - 安装所有 CLI 工具"
            echo "  gh       - 安装 GitHub CLI"
            echo "  skillhub - 安装 SkillHub CLI（国内推荐）"
            echo "  skills   - 安装 skills CLI"
            echo "  login    - GitHub CLI 登录"
            ;;
    esac
}

main "$@"