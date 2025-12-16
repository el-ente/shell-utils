#!/bin/bash
# kubectl-aliases.sh - Useful kubectl aliases and functions
# To use: source kubectl-aliases.sh in your ~/.bashrc

# ============================================
# BASIC KUBECTL COMMANDS
# ============================================
alias kubectl='/c/KubernetesCLI/kubectl.exe'
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgpw='kubectl get pods -o wide'
alias kgpf='kubectl get pods | grep -v Running'  # find problematic pods
alias kd='kubectl describe'
alias kdp='kubectl describe pod'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias klt='kubectl logs --tail=50'
alias kex='kubectl exec -it'
alias kdel='kubectl delete'
alias kapply='kubectl apply -f'
alias kcreate='kubectl create'

# ============================================
# MEMORY AND RESOURCE MONITORING
# ============================================
alias ktop='kubectl top'
alias ktopp='kubectl top pods'
alias ktopn='kubectl top nodes'
alias kmem='kubectl top pods --sort-by=memory'
alias kcpu='kubectl top pods --sort-by=cpu'
alias kmemall='kubectl top pods --all-namespaces --sort-by=memory'
alias kcpuall='kubectl top pods --all-namespaces --sort-by=cpu'

# ============================================
# NAMESPACES
# ============================================
alias kns='kubectl config set-context --current --namespace'
alias kgns='kubectl get namespaces'
alias kcns='kubectl config view --minify --output "jsonpath={..namespace}"'  # current namespace

# ============================================
# DEPLOYMENTS AND SERVICES
# ============================================
alias kgd='kubectl get deployments'
alias kgs='kubectl get services'
alias kgall='kubectl get all'
alias kscale='kubectl scale deployment'

# ============================================
# TROUBLESHOOTING
# ============================================
alias kevents='kubectl get events --sort-by=.metadata.creationTimestamp'
alias keventst='kubectl get events --sort-by=.metadata.creationTimestamp | tail -20'
alias kwatch='kubectl get pods -w'
alias kwatchall='kubectl get pods --all-namespaces -w'

# ============================================
# QUICK OPERATIONS
# ============================================
alias krun='kubectl run temp --image=busybox -it --rm --restart=Never --'
alias kpf='kubectl port-forward'
alias kcp='kubectl cp'

# ============================================
# CONTEXT AND CONFIG
# ============================================
alias kctx='kubectl config current-context'
alias kconfig='kubectl config view'
alias kuse='kubectl config use-context'

# ============================================
# CUSTOM FUNCTIONS
# ============================================

# Show cluster memory summary
kmemory() {
    echo "=========================================="
    echo "           CLUSTER MEMORY SUMMARY         "
    echo "=========================================="
    echo
    echo "📊 Nodes Memory Usage:"
    kubectl top nodes 2>/dev/null || echo "❌ Metrics server not available"
    echo
    echo "🔍 Top 10 Memory Consuming Pods:"
    kubectl top pods --all-namespaces --sort-by=memory 2>/dev/null | head -11 || echo "❌ Metrics server not available"
    echo
    echo "📋 Memory Usage by Namespace:"
    kubectl top pods --all-namespaces 2>/dev/null | awk '
    BEGIN {printf "%-20s %s\n", "NAMESPACE", "MEMORY"}
    NR>1 && $3 ~ /Mi$/ {
        ns[$1] += substr($3, 1, length($3)-2)
    }
    END {
        for (n in ns) {
            if (ns[n] > 0) printf "%-20s %dMi\n", n, ns[n]
        }
    }' | sort -k2 -nr || echo "❌ Metrics server not available"
}

# Show pods with problems
kproblems() {
    echo "=========================================="
    echo "           PROBLEMATIC PODS              "
    echo "=========================================="
    echo
    echo "🚨 Pods with Issues:"
    kubectl get pods --all-namespaces | grep -E "(Error|CrashLoop|Pending|Terminating|Unknown|ImagePull)" || echo "✅ No problematic pods found"
    echo
    echo "📝 Recent Events (Last 10):"
    kubectl get events --all-namespaces --sort-by=.metadata.creationTimestamp | tail -10
}

# Quick cluster overview
kquick() {
    echo "=========================================="
    echo "           CLUSTER QUICK STATUS           "
    echo "=========================================="
    echo "🖥️  Nodes: $(kubectl get nodes --no-headers | wc -l)"
    echo "🐳 Total Pods: $(kubectl get pods --all-namespaces --no-headers | wc -l)"
    echo "📦 Namespaces: $(kubectl get namespaces --no-headers | wc -l)"
    echo "🚀 Deployments: $(kubectl get deployments --all-namespaces --no-headers | wc -l)"
    echo "🌐 Services: $(kubectl get services --all-namespaces --no-headers | wc -l)"
    echo
    echo "Current Context: $(kubectl config current-context)"
    echo "Current Namespace: $(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null || echo 'default')"
}

# Get pod by partial name
kgpn() {
    if [ -z "$1" ]; then
        echo "Usage: kgpn <partial-pod-name>"
        return 1
    fi
    kubectl get pods --all-namespaces | grep "$1"
}

# Describe pod by partial name
kdpn() {
    if [ -z "$1" ]; then
        echo "Usage: kdpn <partial-pod-name>"
        return 1
    fi
    local pod_info=$(kubectl get pods --all-namespaces | grep "$1" | head -1)
    if [ -n "$pod_info" ]; then
        local namespace=$(echo $pod_info | awk '{print $1}')
        local pod_name=$(echo $pod_info | awk '{print $2}')
        kubectl describe pod $pod_name -n $namespace
    else
        echo "Pod not found with pattern: $1"
    fi
}

# Logs from pod by partial name
kln() {
    if [ -z "$1" ]; then
        echo "Usage: kln <partial-pod-name> [follow]"
        return 1
    fi
    local pod_info=$(kubectl get pods --all-namespaces | grep "$1" | head -1)
    if [ -n "$pod_info" ]; then
        local namespace=$(echo $pod_info | awk '{print $1}')
        local pod_name=$(echo $pod_info | awk '{print $2}')
        if [ "$2" = "f" ] || [ "$2" = "follow" ]; then
            kubectl logs $pod_name -n $namespace -f
        else
            kubectl logs $pod_name -n $namespace --tail=50
        fi
    else
        echo "Pod not found with pattern: $1"
    fi
}

# Execute command in pod by partial name
kexn() {
    if [ -z "$1" ]; then
        echo "Usage: kexn <partial-pod-name> [command]"
        return 1
    fi
    local pod_info=$(kubectl get pods --all-namespaces | grep "$1" | head -1)
    if [ -n "$pod_info" ]; then
        local namespace=$(echo $pod_info | awk '{print $1}')
        local pod_name=$(echo $pod_info | awk '{print $2}')
        local cmd="${2:-bash}"
        kubectl exec -it $pod_name -n $namespace -- $cmd
    else
        echo "Pod not found with pattern: $1"
    fi
}

# Show help for aliases
khelp() {
    echo "=========================================="
    echo "           KUBECTL ALIASES HELP          "
    echo "=========================================="
    echo
    echo "📋 BASIC COMMANDS:"
    echo "  k          - kubectl"
    echo "  kgp        - get pods"
    echo "  kgpa       - get pods all namespaces"
    echo "  kgpw       - get pods wide output"
    echo "  kgpf       - get failed pods"
    echo "  kd         - describe"
    echo "  kdp        - describe pod"
    echo "  kl         - logs"
    echo "  klf        - logs follow"
    echo "  kex        - exec -it"
    echo "  kdel       - delete"
    echo
    echo "💾 MEMORY & RESOURCES:"
    echo "  kmem       - top pods by memory"
    echo "  kcpu       - top pods by cpu"
    echo "  ktopn      - top nodes"
    echo "  kmemory    - cluster memory summary"
    echo
    echo "🔧 FUNCTIONS:"
    echo "  kproblems  - show problematic pods"
    echo "  kquick     - cluster quick status"
    echo "  kgpn <name> - get pod by partial name"
    echo "  kdpn <name> - describe pod by partial name"
    echo "  kln <name>  - logs from pod by partial name"
    echo "  kexn <name> - exec into pod by partial name"
    echo
    echo "📁 NAMESPACES:"
    echo "  kns        - set namespace"
    echo "  kgns       - get namespaces" 
    echo "  kcns       - show current namespace"
    echo
    echo "Use 'khelp' to see this help again"
}

# ============================================
# INITIALIZATION MESSAGE
# ============================================
echo "✅ kubectl aliases loaded! Type 'khelp' for available commands"