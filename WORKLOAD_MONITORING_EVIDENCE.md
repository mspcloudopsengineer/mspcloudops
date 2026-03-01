# Workload 监控证据补充
## 客户: Shenzhen Miaodong Technology Co., Ltd

---

## 应用层 Workload 监控

### 自定义指标命名空间
**Namespace**: `Miaodong/Application`

### Workload 健康指标

**1. 响应时间 (ResponseTime)**
- 单位: 毫秒 (ms)
- 阈值: > 500ms 触发告警
- 用途: 监控应用性能

**2. 请求数 (RequestCount)**
- 单位: 次数
- 阈值: < 10 触发告警 (流量异常低)
- 用途: 监控应用流量

**3. 错误率 (ErrorRate)**
- 单位: 百分比 (%)
- 阈值: > 5% 触发告警
- 用途: 监控应用健康度

---

## Workload 告警 (3个)

### 1. 高响应时间告警
```
名称: miaodong-high-response-time
指标: ResponseTime
阈值: > 500ms
周期: 5分钟
评估: 连续2次
```

### 2. 高错误率告警
```
名称: miaodong-high-error-rate
指标: ErrorRate
阈值: > 5%
周期: 5分钟
评估: 连续2次
```

### 3. 低请求数告警
```
名称: miaodong-low-request-count
指标: RequestCount
阈值: < 10
周期: 5分钟
评估: 连续2次
```

---

## 发送自定义指标示例

### 应用代码集成
```bash
# 发送响应时间指标
aws cloudwatch put-metric-data \
  --namespace "Miaodong/Application" \
  --metric-name "ResponseTime" \
  --value 245 \
  --unit Milliseconds

# 发送请求数
aws cloudwatch put-metric-data \
  --namespace "Miaodong/Application" \
  --metric-name "RequestCount" \
  --value 150

# 发送错误率
aws cloudwatch put-metric-data \
  --namespace "Miaodong/Application" \
  --metric-name "ErrorRate" \
  --value 0.5 \
  --unit Percent
```

### Python 集成示例
```python
import boto3
cloudwatch = boto3.client('cloudwatch')

# 发送应用指标
cloudwatch.put_metric_data(
    Namespace='Miaodong/Application',
    MetricData=[
        {
            'MetricName': 'ResponseTime',
            'Value': 245,
            'Unit': 'Milliseconds'
        },
        {
            'MetricName': 'ErrorRate',
            'Value': 0.5,
            'Unit': 'Percent'
        }
    ]
)
```

---

## 更新后的 Dashboard

### Miaodong-Infrastructure-Health
**包含组件**:

**Infrastructure 监控**:
1. EC2 CPU 利用率

**Workload 监控**:
2. 应用响应时间 (ms)
3. 应用请求数
4. 应用错误率 (%)
5. 应用错误日志实时查询

---

## 完整监控架构

### Infrastructure 层 (8个告警)
- CPU 利用率 (4个实例)
- 状态检查 (4个实例)

### Workload 层 (3个告警)
- 响应时间
- 请求数
- 错误率

### 日志层
- CloudWatch Logs: `/miaodong/dev/application`
- 保留期: 90天
- 错误日志过滤和告警

---

## 验证命令

### 查看 workload 指标
```bash
aws cloudwatch get-metric-statistics \
  --namespace Miaodong/Application \
  --metric-name ResponseTime \
  --start-time 2026-03-01T00:00:00Z \
  --end-time 2026-03-01T23:59:59Z \
  --period 300 \
  --statistics Average
```

### 查看所有告警
```bash
aws cloudwatch describe-alarms \
  --region us-east-1 \
  --query 'MetricAlarms[].[AlarmName,Namespace,MetricName,Threshold]'
```

---

## 满足要求

| 层级 | 指标 | 告警 | Dashboard |
|------|------|------|-----------|
| Infrastructure | ✅ CPU, 状态检查 | ✅ 8个 | ✅ |
| Workload | ✅ 响应时间, 请求数, 错误率 | ✅ 3个 | ✅ |
| Logs | ✅ 应用日志 | ✅ 错误过滤 | ✅ |

**总计**: 11个告警 + 1个实时 Dashboard + 应用日志

---

**客户**: Shenzhen Miaodong Technology Co., Ltd  
**状态**: ✅ Infrastructure + Workload 监控完整  
**日期**: 2026-03-01
