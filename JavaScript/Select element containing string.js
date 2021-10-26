for (const span of document.querySelectorAll("h3")) {
    if (span.textContent.includes("Bienvenido")) {
      span.classList.add("hola");
    }
}