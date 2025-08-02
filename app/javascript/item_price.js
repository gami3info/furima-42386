const calculatePrice = () => {

  const priceInput = document.getElementById("item-price");

  if (!priceInput) {
    return;
  }

  priceInput.addEventListener("input", () => {
    const inputValue = priceInput.value;
    const addTaxDom = document.getElementById("add-tax-price");
    const tax = Math.floor(inputValue * 0.1);
    addTaxDom.innerHTML = tax;
    const profitDom = document.getElementById("profit");
    profitDom.innerHTML = inputValue - tax;
  });
};

window.addEventListener("turbo:load", calculatePrice);
window.addEventListener("turbo:render", calculatePrice);