FROM ubuntu:latest

RUN apt update && apt install -y sudo git vim curl zsh

ARG USERNAME=ubuntu
ARG PASSWORD=ubuntu

# ユーザ ubuntu にパスワードを設定し、 sudo 権限を付与。
RUN \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

CMD ["echo", "Hello docker world!"]
