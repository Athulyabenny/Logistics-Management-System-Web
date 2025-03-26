document.getElementById("track-btn").addEventListener("click", function () {
    const trackingId = document.getElementById("tracking-id").value;
    fetch(`/api/Logistics/Track?id=${trackingId}`)
        .then(response => response.text())
        .then(data => {
            document.getElementById("result").innerText = data;
        });
});
document.getElementById("track-btn").addEventListener("click", function () {
    const trackingId = document.getElementById("tracking-id").value;

    if (trackingId.trim() !== "") {
        // Use Fetch API to call the back-end
        fetch(`/api/Logistics/TrackShipment?id=${trackingId}`)
            .then(response => response.text())
            .then(data => {
                // Display the response on the page
                document.getElementById("result").innerText = data;
            })
            .catch(error => {
                console.error("Error:", error);
                document.getElementById("result").innerText = "Error contacting the server.";
            });
    } else {
        document.getElementById("result").innerText = "Please enter a valid Tracking ID.";
    }
});
