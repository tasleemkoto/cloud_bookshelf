import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "bookSelect",
    "bookAuthor",
    "bookFormat",
    "bookAvailability",
    "bookLocation",
    "bookQuantity",
  ];

  connect() {
    console.log("Checkout controller connected");
  }

  updateDetails(event) {
    const bookId = event.target.value;

    if (bookId) {
      fetch(`/books/${bookId}/details`)
        .then((response) => response.json())
        .then((data) => {
          this.bookAuthorTarget.textContent = data.author || "N/A";
          this.bookFormatTarget.textContent = data.format || "N/A";
          this.bookAvailabilityTarget.textContent = data.availability ? "Yes" : "No";
          this.bookLocationTarget.textContent = data.location || "N/A";
          this.bookQuantityTarget.textContent = data.quantity || "N/A";
        });
    } else {
      this.clearDetails();
    }
  }

  clearDetails() {
    this.bookAuthorTarget.textContent = "";
    this.bookFormatTarget.textContent = "";
    this.bookAvailabilityTarget.textContent = "";
    this.bookLocationTarget.textContent = "";
    this.bookQuantityTarget.textContent = "";
  }
}
