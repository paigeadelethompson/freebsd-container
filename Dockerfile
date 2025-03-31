# Build argument for FreeBSD version
ARG FREEBSD_VERSION=14.2-RELEASE

# Use the imported FreeBSD base image
FROM temp-freebsd-${FREEBSD_VERSION//./-}

# Bootstrap and install pkg
RUN /bin/sh -c 'pkg bootstrap -y && pkg update && pkg upgrade -y'

# Set the default shell to tcsh
SHELL ["/bin/tcsh", "-c"]

# Set the default command
CMD ["/bin/tcsh", "-c", "/bin/tcsh"] 