#!/bin/tcsh

# Array of FreeBSD versions to process
set versions = ( \
    "14.2-RELEASE" \
    "14.1-RELEASE" \
)

# Base URL for FreeBSD downloads
set base_url = "https://download.freebsd.org/ftp/releases/amd64/amd64"

# Get host FreeBSD version
set host_version = `uname -r | cut -d- -f1-2`
echo "Host FreeBSD version: $host_version"

# Main loop to process all versions
foreach version ($versions)
    set temp_name = "temp-freebsd-`echo $version | tr . - | tr A-Z a-z`"
    set final_name = "localhost/freebsd:`echo $version | tr . - | tr A-Z a-z`"
    echo "Processing FreeBSD $version..."
    
    # Check if final image already exists and remove it
    podman image exists "$final_name"
    if ($status == 0) then
        echo "Removing existing image $final_name..."
        podman rmi "$final_name"
    endif
    
    # Import the base image with temp name
    echo "Importing FreeBSD $version..."
    podman import --os freebsd "$base_url/$version/base.txz" "$temp_name"
    if ($status == 0) then
        echo "Successfully imported $temp_name"
        
        # Build the updated image
        echo "Building updated image for $version..."
        podman build --format docker --build-arg FREEBSD_VERSION="`echo $version | tr . - | tr A-Z a-z`" -t "$temp_name" .
        if ($status == 0) then
            echo "Successfully built $temp_name"
            
            # Tag the temp image with the final name
            podman tag "$temp_name" "$final_name"
            
            # If this version matches the host version, tag it as latest
            if ("$version" == "$host_version") then
                echo "Tagging $version as latest (matches host version)"
                podman tag "$temp_name" "localhost/freebsd:latest"
            endif
            
            # Remove the temp image
            podman rmi "$temp_name"
            echo "Successfully tagged as $final_name"
            
            # Clean up any dangling images
            echo "Cleaning up dangling images..."
            podman image prune -f
        else
            echo "Failed to build $temp_name"
            podman rmi "$temp_name"
            echo "Skipping remaining versions due to error..."
            exit 1
        endif
    else
        echo "Failed to import $temp_name"
        echo "Skipping remaining versions due to error..."
        exit 1
    endif
end

# Final cleanup of any remaining dangling images
echo "Performing final cleanup..."
podman image prune -f 