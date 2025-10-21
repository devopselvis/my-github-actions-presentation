# Job Containers Quick Reference

## 🚀 Quick Start
1. Go to GitHub Actions tab
2. Select "Job Containers Demo"  
3. Click "Run workflow"
4. Choose environment (development/staging/production)
5. Click green "Run workflow" button

## 📋 Job Summary (5 jobs, ~6 minutes total)

| Job | Purpose | Container | Key Features |
|-----|---------|-----------|--------------|
| **Basic Container** | Simple container usage | `node:18-alpine` | Environment vars, basic setup |
| **Services Demo** | Database connectivity | `python:3.11-slim` | PostgreSQL + Redis services |
| **Multi-Container** | Cross-platform testing | Alpine/Ubuntu/Amazon Linux | Matrix strategy |
| **Custom Config** | Advanced options | `nginx:alpine` | Custom user, workdir, options |
| **Networking** | Container communication | `curlimages/curl` | Service networking, ports |

## 💡 Key Teaching Points

### Container Basics
```yaml
container:
  image: node:18-alpine          # Specify image
  env:                          # Environment variables  
    NODE_ENV: development
  options: --cpus 1             # Docker options
```

### Service Containers
```yaml
services:
  postgres:                     # Service name
    image: postgres:15          # Service image
    env:                       # Service environment
      POSTGRES_PASSWORD: pass
    options: --health-cmd pg_isready  # Health checks
```

### Matrix with Containers
```yaml
strategy:
  matrix:
    os: [alpine, ubuntu]        # Different base images
container:
  image: ${{ matrix.os }}       # Dynamic container selection
```

## 🔍 What to Watch For

### Expected Outputs
- ✅ Node.js version information
- ✅ Database connection success
- ✅ Redis cache operations  
- ✅ Cross-platform compatibility
- ✅ Network connectivity tests

### Common Issues
- ❌ Container pull timeouts (retry)
- ❌ Service health check failures (temporary)
- ❌ Network connectivity issues (usually resolves)

## 🎤 Presenter Notes

### Opening Hook
> "Imagine running your CI/CD in exactly the same environment every time, regardless of the underlying runner. That's the power of job containers!"

### Key Questions to Ask
1. "What problems have you faced with environment consistency?"
2. "How do you currently manage different tool versions?"
3. "Who's worked with Docker before?"

### Demo Flow (15 minutes)
- **2 min**: Introduction & trigger workflow
- **3 min**: Job 1 - Basic containers
- **4 min**: Job 2 - Service containers  
- **3 min**: Job 3 - Multi-platform
- **2 min**: Job 4 - Advanced config
- **1 min**: Job 5 - Networking

### Wrap-up Points
- Consistency across environments
- Isolation and security benefits
- Easy local reproduction
- Faster setup with pre-built images

## 🛠️ Backup Plans

### If Demo Fails
1. Show pre-recorded screenshots
2. Walk through YAML explanation
3. Use local Docker examples

### If Time is Short
Focus on Jobs 1 & 2 only - they cover 80% of use cases

### Extension Activities
- Modify container versions live
- Add new service containers
- Discuss security implications

## 📞 Emergency Contacts
- GitHub Status: https://www.githubstatus.com/
- Actions Documentation: https://docs.github.com/actions