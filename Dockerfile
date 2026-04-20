FROM localhost/android-sdk:34-33.0.1

ARG flutter_version=3.27.4

ENV FLUTTER_HOME=/opt/flutter \
    FLUTTER_VERSION=$flutter_version
ENV FLUTTER_ROOT=$FLUTTER_HOME

ENV PATH ${PATH}:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin

ENV CHROME_EXECUTABLE=/usr/bin/chromium

ENV TAR_OPTIONS="--no-same-owner"

RUN set -o xtrace \
    && apt-get update \
    && apt-get install -y chromium \
    && apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git ${FLUTTER_HOME}

RUN yes | flutter doctor --android-licenses \
    && flutter doctor \
    && flutter doctor -v \
    && chown -R root:root ${FLUTTER_HOME}

RUN flutter precache --android --linux
