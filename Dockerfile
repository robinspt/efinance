FROM continuumio/miniconda3

# 镜像元数据标签 - 用于关联 GitHub 仓库
LABEL org.opencontainers.image.source="https://github.com/robinspt/efinance"
LABEL org.opencontainers.image.description="efinance - 免费开源的 Python 金融数据获取库"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.title="efinance"
LABEL org.opencontainers.image.url="https://github.com/robinspt/efinance"
LABEL org.opencontainers.image.documentation="https://github.com/robinspt/efinance/blob/main/README.md"
LABEL maintainer="robinspt"

# 默认工作目录
ARG HOME=/root
WORKDIR $HOME

# 安装依赖
RUN pip install efinance
