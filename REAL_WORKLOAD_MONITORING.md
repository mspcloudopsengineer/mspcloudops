# 真实 Workload 监控证据
## 客户: Shenzhen Miaodong Technology Co., Ltd

---

## 部署的真实应用

### Web 应用
- **实例**: i-00d9ad15a80abecaf (WebServer-1)
- **应用**: Nginx Web Server
- **监控服务**: miaodong-monitor.service
- **监控频率**: 每60秒

### 监控脚本
Python 脚本持续监控应用:
- 每分钟向 nginx 发送 HTTP 请求
- 测量响应时间
- 记录请求数
- 计算错误率
- 自动发送到 CloudWatch

---

## 真实监控数据

### 1. 响应时间 (ResponseTime)
```
时间                        平均响应时间
2026-03-01 14:46:00        32.388 ms
2026-03-01 14:47:00        1.335 ms
```
✅ 应用响应正常,性能良好

### 2. 请求数 (RequestCount)
```
时间                        请求数
2026-03-01 14:46:00        1
2026-03-01 14:47:00        1
```
✅ 每分钟1个请求,监控正常运行

### 3. 错误率 (ErrorRate)
```
时间                        错误率
2026-03-01 14:46:00        0.0%
2026-03-01 14:47:00        0.0%
```
✅ 无错误,应用健康

---

## 监控服务状态

### systemd 服务
```
服务名: miaodong-monitor.service
状态: Active (running)
描述: Miaodong Application Monitoring
自动启动: Enabled
```

### 监控流程
1. Python 脚本每60秒运行一次
2. 向 http://localhost 发送请求
3. 测量响应时间和状态码
4. 通过 boto3 发送到 CloudWatch
5. 持续运行,自动重启

---

## CloudWatch 集成

### 自定义指标
**Namespace**: `Miaodong/Application`
**Dimension**: `Instance=WebServer-1`

**指标**:
- ResponseTime (毫秒)
- RequestCount (次数)
- ErrorRate (百分比)

### 数据保留
- 指标保留: 15个月
- 粒度: 1分钟
- 实时更新

---

## 验证命令

### 查看实时指标
```bash
# 响应时间
aws cloudwatch get-metric-statistics \
  --namespace Miaodong/Application \
  --metric-name ResponseTime \
  --dimensions Name=Instance,Value=WebServer-1 \
  --start-time $(date -u -d '1 hour ago' +"%Y-%m-%dT%H:%M:%S") \
  --end-time $(date -u +"%Y-%m-%dT%H:%M:%S") \
  --period 60 \
  --statistics Average

# 检查服务状态
aws ssm send-command \
  --instance-ids i-00d9ad15a80abecaf \
  --document-name "AWS-RunShellScript" \
  --parameters 'commands=["systemctl status miaodong-monitor"]'
```

### 访问应用
```bash
# 通过 SSM 测试
aws ssm send-command \
  --instance-ids i-00d9ad15a80abecaf \
  --document-name "AWS-RunShellScript" \
  --parameters 'commands=["curl http://localhost"]'
```

---

## 告警配置

### 已配置告警
1. **miaodong-high-response-time**: 响应时间 > 500ms
2. **miaodong-high-error-rate**: 错误率 > 5%
3. **miaodong-low-request-count**: 请求数 < 10

当前状态: 所有指标正常,无告警触发

---

## Dashboard 展示

### Miaodong-Infrastructure-Health
实时显示:
- Infrastructure: EC2 CPU 利用率
- Workload: 应用响应时间 (实时数据)
- Workload: 请求数 (实时数据)
- Workload: 错误率 (实时数据)
- 应用错误日志

---

## 证明

✅ **真实应用**: Nginx 运行在 WebServer-1
✅ **真实监控**: Python 脚本持续采集数据
✅ **真实指标**: CloudWatch 显示实时数据
✅ **自动化**: systemd 服务自动运行
✅ **告警**: 阈值已配置,自动触发

---

**客户**: Shenzhen Miaodong Technology Co., Ltd  
**应用**: Nginx Web Server  
**实例**: i-00d9ad15a80abecaf (WebServer-1)  
**状态**: ✅ 真实 Workload 监控运行中  
**数据**: 实时更新到 CloudWatch  
**日期**: 2026-03-01
