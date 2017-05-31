FROM centos:7.2.1511

MAINTAINER Jim Holmstrom <jim.holmstroem@gmail.com>

ENV LUA_VERSION 5.3.4
ENV LUAROCKS_VERSION 2.4.2
ENV LUAROCKS_INSTALL luarocks-$LUAROCKS_VERSION
ENV TMP_LOC /tmp/luarocks

# lua env
ENV WITH_LUA /usr/local/
ENV LUA_LIB /usr/local/lib/lua
ENV LUA_INCLUDE /usr/local/include

RUN yum install -y make tar unzip gcc gcc-devel openssl-devel readline-devel zip unzip inscurl\
    && yum clean all \
    && curl -L http://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz | tar xzf - \
    && cd /lua-$LUA_VERSION \
    && make linux test \
    && make install \
    && cd .. \
    && rm /lua-$LUA_VERSION -rf \
    && curl -OL https://luarocks.org/releases/${LUAROCKS_INSTALL}.tar.gz \
    && tar xvf $LUAROCKS_INSTALL.tar.gz \
    && rm $LUAROCKS_INSTALL.tar.gz \
    && mv $LUAROCKS_INSTALL $TMP_LOC \
    && cd $TMP_LOC \
    && ./configure --with-lua=$WITH_LUA --with-lua-include=$LUA_INCLUDE --with-lua-lib=$LUA_LIB \
    && make build \
    && make install \
    && mkdir /usr/src/app


WORKDIR  /usr/src/app
