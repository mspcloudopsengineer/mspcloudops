# 事件管理和动态监控证据
## 客户: Shenzhen Miaodong Technology Co., Ltd

---

## ✅ a. 定义和收集健康指标

### 监控指标
**EC2 实例指标** (4台实例):
- CPU 利用率 (CPUUtilization)
- 状态检查失败 (StatusCheckFailed)
- 网络流量 (NetworkIn/NetworkOut)
- 磁盘读写 (DiskReadOps/DiskWriteOps)

**CloudWatch 日志组**:
- `/miaodong/dev/application` (90天保留期)

### 数据收集
- **工具**: AWS CloudWatch
- **频率**: 每5分钟
- **保留期**: 15个月 (指标), 90天 (日志)

---

## ✅ b. 导出应用日志

### 日志配置
**日志组**: `/miaodong/dev/application`
- 保留期: 90天
- 用途: 应用错误和故障排查
- 导出: 支持导出到 S3

### 日志查询示例
```bash
# 查询最近错误
aws logs filter-log-events \
  --log-group-name /miaodong/dev/application \
  --filter-pattern "ERROR"

# 导出日志到 S3
aws logs create-export-task \
  --log-group-name /miaodong/dev/application \
  --destination miaodong-dev-storage-ee4d262b
```

---

## ✅ c. 定义告警阈值

### 已创建告警 (8个)

**CPU 告警** (4个实例):
- 指标: CPUUtilization
- 阈值: > 80%
- 周期: 5分钟
- 评估: 连续2次
- 告警名称: `miaodong-{instance-id}-high-cpu`

**状态检查告警** (4个实例):
- 指标: StatusCheckFailed
- 阈值: >= 1
- 周期: 1分钟
- 评估: 连续2次
- 告警名称: `miaodong-{instance-id}-status-check`

### 告警列表
```
miaodong-i-03cca5f2a1343fc35-high-cpu (CPU > 80%)
miaodong-i-03cca5f2a1343fc35-status-check (状态检查)
miaodong-i-0731200f29553e746-high-cpu (CPU > 80%)
miaodong-i-0731200f29553e746-status-check (状态检查)
miaodong-i-00d9ad15a80abecaf-high-cpu (CPU > 80%)
miaodong-i-00d9ad15a80abecaf-status-check (状态检查)
miaodong-i-0c86e22b7d6ac02a5-high-cpu (CPU > 80%)
miaodong-i-0c86e22b7d6ac02a5-status-check (状态检查)
```

---

## ✅ d. 使用标签组织资源

### 标签策略
所有资源已标记:
- `Company`: Shenzhen-Miaodong-Technology
- `Environment`: production
- `MonitoringEnabled`: true

### 标签用途
- 成本分配和跟踪
- 资源分组和过滤
- 自动化操作目标
- 合规性审计

### 验证命令
```bash
# 按标签查询资源
aws ec2 describe-instances \
  --filters "Name=tag:Company,Values=Shenzhen-Miaodong-Technology" \
  --query 'Reservations[].Instances[].[InstanceId,Tags]'
```

---

## 📊 实时 Dashboard

### CloudWatch Dashboard
**名称**: `Miaodong-Infrastructure-Health`

**组件**:
1. EC2 CPU 利用率图表
2. 实例状态检查图表
3. 应用日志实时查询

**访问**: AWS Console → CloudWatch → Dashboards → Miaodong-Infrastructure-Health

---

## 验证命令

### 查看告警
```bash
aws cloudwatch describe-alarms \
  --region us-east-1 \
  --alarm-name-prefix "miaodong-"
```

### 查看指标
```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=i-03cca5f2a1343fc35 \
  --start-time 2026-03-01T00:00:00Z \
  --end-time 2026-03-01T23:59:59Z \
  --period 3600 \
  --statistics Average
```

### 查看日志
```bash
aws logs tail /miaodong/dev/application --follow
```

---

## 满足要求总结

| 要求 | 实现 | 证据 |
|------|------|------|
| a. 定义和收集指标 | ✅ | CloudWatch 指标 (CPU, 状态检查) |
| b. 导出应用日志 | ✅ | CloudWatch 日志组 (90天保留) |
| c. 定义告警阈值 | ✅ | 8个告警 (CPU > 80%, 状态检查) |
| d. 使用标签组织 | ✅ | 所有资源已标记 (Company, Environment) |
| 实时 Dashboard | ✅ | Miaodong-Infrastructure-Health |

---

**客户**: Shenzhen Miaodong Technology Co., Ltd  
**状态**: ✅ 事件管理和动态监控已完整实施  
**日期**: 2026-03-01  
**Dashboard**: CloudWatch → Miaodong-Infrastructure-Health
