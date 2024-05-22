window.addEventListener('message', function(event) {
    if (event.data.action == "openScratchCard") {
        const scratchCardsContainer = document.createElement("div");
        scratchCardsContainer.classList.add("scratchcard");

        const headerContainer = document.createElement("div");
        headerContainer.classList.add("header-container");

        const logoImg = document.createElement("img");
        logoImg.src = "fx_logo.png";
        logoImg.alt = "";
        logoImg.classList.add("fx-logo");
        headerContainer.appendChild(logoImg);

        const logoTextContainer = document.createElement("div");
        logoTextContainer.classList.add("logoText-container");
        const logoText = document.createElement("h1");
        logoText.textContent = "SCRATCH CARD";
        logoTextContainer.appendChild(logoText);
        headerContainer.appendChild(logoTextContainer);

        const closeButton = document.createElement("div");
        closeButton.classList.add("close-button");
        headerContainer.appendChild(closeButton);

        scratchCardsContainer.appendChild(headerContainer);

        const mainContainer = document.createElement("div");
        mainContainer.classList.add("main-container");

        const prices = Array.from({ length: 6 }, () => {
            return Math.random() < event.data.tryAgainPercentage ? "" : Math.floor(Math.random() * (event.data.maxPrice - event.data.minPrice + 1)) + event.data.minPrice;
        });

        prices.forEach((price, index) => {
            const underScratch = document.createElement("div");
            underScratch.classList.add("under-scratch");

            const priceH1 = document.createElement("h1");
            priceH1.classList.add("price");
            priceH1.textContent = price !== "" ? `$${price}` : "Try Again";
            underScratch.appendChild(priceH1);

            const canvas = document.createElement("canvas");
            canvas.classList.add("scratch");
            canvas.id = `scratch${index + 1}`;
            underScratch.appendChild(canvas);

            mainContainer.appendChild(underScratch);

            const context = canvas.getContext("2d");

            const scratchProgress = new Array(canvas.width * canvas.height).fill(false);
            let moneyGiven = false;

            const init = () => {
                context.fillStyle = "rgba(30,30,30,1)";
                context.fillRect(0, 0, canvas.width, canvas.height);
                const img = new Image();
                img.onload = () => {
                    context.drawImage(img, 0, 0, canvas.width, canvas.height);
                };
                img.src = "dollarsign.png";
            };

            let isDragged = false;

            canvas.addEventListener("mousedown", (event) => {
                isDragged = true;
                scratch(event);
            });

            canvas.addEventListener("mouseup", () => {
                isDragged = false;
                checkScratchProgress();
            });

            canvas.addEventListener("mouseleave", () => {
                isDragged = false;
                checkScratchProgress();
            });

            const getCursorPosition = (canvas, event) => {
                const rect = canvas.getBoundingClientRect();
                const scaleX = canvas.width / rect.width;
                const scaleY = canvas.height / rect.height;
                return {
                    x: (event.clientX - rect.left) * scaleX,
                    y: (event.clientY - rect.top) * scaleY
                };
            };
            
            canvas.addEventListener("mousemove", (event) => {
                if (isDragged) {
                    const { x, y } = getCursorPosition(canvas, event);
                    scratch(x, y);
                }
            });
            
            const scratch = (x, y) => {
                context.globalCompositeOperation = "destination-out";
                context.beginPath();
                const scratchRadius = Math.min(canvas.width, canvas.height) * 0.1;
                context.arc(x, y, scratchRadius, 0, 2 * Math.PI);
                context.fill();
            
                const pixelIndex = Math.floor(y) * canvas.width + Math.floor(x);
                scratchProgress[pixelIndex] = true;
            };

            const checkScratchProgress = () => {
                if (moneyGiven) return;

                const scratchedPixels = scratchProgress.filter((isScratched) => isScratched);
                const scratchPercentage = (scratchedPixels.length / (canvas.width * canvas.height)) * 100;

                if (scratchPercentage > 0.4) {
                    moneyGiven = true;
                    const price = prices[index];
                    if (price !== "") {
                        $.post('https://fx_scratchcards/giveMoney', JSON.stringify({ price: price }));
                    }
                }
            };

            init();
        });

        scratchCardsContainer.appendChild(mainContainer);
        document.body.appendChild(scratchCardsContainer);

        setTimeout(() => {
            scratchCardsContainer.classList.add('visible');
        }, 50);

        document.querySelector('.close-button').addEventListener('click', function() {
            scratchCardsContainer.classList.remove('visible');
            setTimeout(() => {
                document.body.innerHTML = '';
                $.post('https://fx_scratchcards/exit', JSON.stringify({}));
            }, 300); 
        });
    }
});