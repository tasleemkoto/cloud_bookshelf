document.addEventListener("DOMContentLoaded", () => {
  const bookSelect = document.getElementById("book-select");
  const details = {
    author: document.getElementById("book-author"),
    format: document.getElementById("book-format"),
    availability: document.getElementById("book-availability"),
    location: document.getElementById("book-location"),
    quantity: document.getElementById("book-quantity"),
  };

  bookSelect.addEventListener("change", async (event) => {
    const bookId = event.target.value;

    if (bookId) {
      const response = await fetch(`/books/${bookId}/details`);
      const data = await response.json();

      details.author.textContent = data.author || "N/A";
      details.format.textContent = data.format || "N/A";
      details.availability.textContent = data.availability ? "Yes" : "No";
      details.location.textContent = data.location || "N/A";
      details.quantity.textContent = data.quantity || "N/A";
    } else {
      // Clear details if no book is selected
      Object.values(details).forEach((element) => (element.textContent = ""));
    }
  });
});


