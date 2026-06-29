# Evolution WhatsApp Infrastructure

Infraestrutura completa para deploy do **Evolution API** (WhatsApp Web monitoring) com stack de monitoramento (Prometheus + Grafana + cAdvisor), otimizada para **Coolify** e Docker Compose standalone.

## 🏗️ Arquitetura

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   WhatsApp  │────►│  Evolution  │────►│  RabbitMQ   │────►│    CRM      │
│             │     │  API        │     │  (externo)  │     │  (Postgres) │
└─────────────┘     └──────┬──────┘     └─────────────┘     └─────────────┘
                           │
                           ▼
                    ┌─────────────┐
                    │  cAdvisor   │◄── métricas de container
                    └──────┬──────┘
                           │
                           ▼
                    ┌─────────────┐
                    │  Prometheus │◄── storage de métricas
                    └──────┬──────┘
                           │
                           ▼
                    ┌─────────────┐
                    │   Grafana   │◄── dashboards
                    └─────────────┘
```

## 📁 Estrutura

```
.
├── docker-compose.yml          # Stack completa (Coolify-friendly)
├── .env.example                # Template de variáveis
├── .gitignore
├── prometheus/
│   └── prometheus.yml          # Config de scrape
├── grafana/
│   ├── provisioning/
│   │   ├── datasources/
│   │   │   └── datasource.yml
│   │   └── dashboards/
│   │       └── dashboard.yml
│   └── dashboards/
│       └── evolution-dashboard.json
└── README.md
```

## 🚀 Deploy no Coolify

1. **Clone este repo** no seu servidor ou faça upload via Git no Coolify
2. **Configure as variáveis** no painel Environment Variables do Coolify:

| Variable | Descrição | Exemplo |
|----------|-----------|---------|
| `SERVER_URL` | URL pública da API | `https://evo.seudominio.com` |
| `AUTHENTICATION_API_KEY` | Chave de API (mín. 32 chars) | `sua-chave-forte-aqui` |
| `DATABASE_CONNECTION_URI` | Postgres externo | `postgresql://evo:pass@host:5432/evolution?schema=public` |
| `RABBITMQ_URI` | RabbitMQ externo | `amqp://evo:pass@host:5672/evolution` |
| `GRAFANA_ADMIN_USER` | Usuário Grafana | `admin` |
| `GRAFANA_ADMIN_PASSWORD` | Senha Grafana | `senha-segura` |

3. **Deploy** — o Coolify vai subir todos os serviços

## 📊 Monitoramento

Acessos (configure domínios no Coolify):
- **Grafana**: `https://grafana.seudominio.com` (admin/admin)
- **Prometheus**: `https://prometheus.seudominio.com`
- **Evolution API**: `https://evo.seudominio.com`

Dashboards pré-configurados:
- Memory Usage % / CPU Usage %
- Network I/O
- OOM Kills
- Disk Usage

## ⚙️ Otimizações aplicadas

| Otimização | Valor | Impacto |
|------------|-------|---------|
| `DATABASE_SAVE_DATA_NEW_MESSAGE` | `false` | Banco do Evolution não cresce (CRM é fonte da verdade) |
| `LOG_LEVEL` | `ERROR,WARN` | Menos I/O de disco |
| `LOG_BAILEYS` | `error` | Silencia logs de protocolo |
| Cache | Desabilitado | ~100MB+ de RAM economizados |
| Integrações | Todas `false` | Menor attack surface |
| `mem_limit` | `3g` | Protege contra OOM no host |

## 📈 Scaling

| Cenário | Ação |
|---------|------|
| 15–20 números | Container único, 3GB RAM |
| 20–40 números | Aumentar `mem_limit` para 5GB ou shardar em 2 containers |
| 40+ números | Múltiplos containers com `DATABASE_CONNECTION_CLIENT_NAME` diferente |

## 🛠️ Comandos úteis

```bash
# Ver consumo de recursos em tempo real
docker stats

# Logs do Evolution
docker logs -f evolution-api

# Reiniciar stack
docker compose restart

# Escalar horizontal (duplicar serviço)
# Edite docker-compose.yml, copie o bloco evolution-api para evolution-api-2
# Altere DATABASE_CONNECTION_CLIENT_NAME para evolution_shard_2
```

## 📝 Licença

MIT — use à vontade para seus projetos.
