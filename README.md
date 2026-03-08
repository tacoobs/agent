# taco - Taco Ops Agent

Server health check agent that auto-detects your environment and sends reports to any webhook (N8N, Zapier, Make, etc).

## Quick Install

```bash
curl -sSL https://raw.githubusercontent.com/tacoobs/agent/main/install.sh | sudo bash
sudo taco install
```

## What it monitors

**Always (any Linux):**
- Disk usage (all partitions)
- CPU / Load average
- Memory
- Uptime
- Failed systemd services

**Auto-detected:**
- Docker — container status, CPU/mem per container, log sizes
- PostgreSQL — connections, dead tuples, vacuum status
- Redis / Sidekiq — queue lengths
- Nginx — running status

## Commands

| Command | Description |
|---|---|
| `sudo taco install` | Interactive setup wizard |
| `sudo taco config` | Edit configuration |
| `sudo taco config set KEY value` | Change a single setting |
| `sudo taco run` | Execute health check and send report |
| `sudo taco test` | Send a test report to validate webhook |
| `sudo taco status` | Show config, timer, and last run |
| `sudo taco logs` | Show recent execution logs |
| `sudo taco uninstall` | Remove config, timer, and logs |

## Webhook Payload

```json
{
  "server": "my-server",
  "ip": "1.2.3.4",
  "timestamp": "2026-03-07T14:00:00Z",
  "status": "ok | warning | critical",
  "uptime_days": 60,
  "capabilities": ["docker", "postgresql", "redis", "nginx"],
  "system": {
    "disk": [{ "mount": "/", "usage_pct": 43, "available": "64G" }],
    "load_average": { "load_1m": 1.2, "cpus": 4 },
    "memory": { "usage_pct": 38 }
  },
  "docker": { "containers": [...], "stats": [...], "log_size_gb": 0 },
  "sidekiq": { "default": 0, "low": 0, "total": 0 },
  "postgresql": { "connections": 101, "tables_with_dead_tuples": [...] },
  "alerts": [{ "level": "warning", "component": "disk", "message": "Disco / em 85%" }]
}
```

## Requirements

- Linux with systemd
- `curl` and `python3`
- `sudo` access

## License

MIT
