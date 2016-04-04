# docker build -t nuts/sshd .
# docker run -d nuts/sshd
# $ ssh nobita@xxx.xxx.xxx.xxx or ssh root@xxx.xxx.xxx.xxx

FROM centos:6

RUN yum install -y passwd openssh openssh-server openssh-clients sudo

## modify root
RUN echo root | passwd --stdin root
RUN mkdir -p /root/.ssh \
    && chown root /root/.ssh \
    && chmod 700 /root/.ssh
ADD ./root/id_rsa.pub /root/.ssh/authorized_keys
RUN chown root /root/.ssh/authorized_keys \
    && chmod 600 /root/.ssh/authorized_keys

## setup sshd and generate ssh-keys by init script
ADD ./sshd_config /etc/ssh/sshd_config
RUN /etc/init.d/sshd start && /etc/init.d/sshd stop

## Seems we cannnot fix public port number
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

