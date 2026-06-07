let apps = [];

// DOM Elements
const grid = document.getElementById("appGrid");
const searchInput = document.getElementById("searchInput");
const categorySelect = document.getElementById("categorySelect");

// Fetch and parse the CSV file
async function loadAppsData() {
    try {
        const response = await fetch("apps.csv");
        if (!response.ok) throw new Error("Network response was not ok");
        const csvText = await response.text();

        parseCSV(csvText);
        initializeUI();
    } catch (error) {
        console.error("Failed to load CSV:", error);
        grid.innerHTML = `<div class="message" style="color: #FFB4AB;">Failed to load apps.csv.<br>Make sure you are running a local web server (like VS Code Live Server) and the file is in the correct directory.</div>`;
    }
}

// Custom CSV parser to handle quotes containing commas
function parseCSV(text) {
    const lines = text.trim().split("\n");

    // Skip the header row (index 0) and parse the rest
    apps = lines
        .slice(1)
        .map((line) => {
            const row = [];
            let inQuotes = false;
            let currentVal = "";

            for (let i = 0; i < line.length; i++) {
                const char = line[i];
                if (char === '"') {
                    inQuotes = !inQuotes;
                } else if (char === "," && !inQuotes) {
                    row.push(currentVal.trim());
                    currentVal = "";
                } else {
                    currentVal += char;
                }
            }
            row.push(currentVal.trim());

            // Map to object based on new CSV structure: name,url,packagename,category,description,source
            return {
                name: row[0] || "",
                url: row[1] || "",
                packageName: row[2] || "",
                category: row[3] || "Uncategorized",
                description: row[4] || "",
                source: (row[5] || "").toLowerCase().trim(),
            };
        })
        .filter((app) => app.name !== ""); // Remove any empty rows
}

function initializeUI() {
    // Populate Category Dropdown
    const uniqueCategories = [...new Set(apps.map((app) => app.category))].sort();
    uniqueCategories.forEach((category) => {
        const option = document.createElement("option");
        option.value = category;
        option.textContent = category;
        categorySelect.appendChild(option);
    });

    // Add Event Listeners
    searchInput.addEventListener("input", renderApps);
    categorySelect.addEventListener("change", renderApps);

    // Initial Render
    renderApps();
}

// Render Apps Function
function renderApps() {
    const searchTerm = searchInput.value.toLowerCase();
    const selectedCategory = categorySelect.value;

    const filteredApps = apps.filter((app) => {
        const matchesSearch =
            app.name.toLowerCase().includes(searchTerm) ||
            app.description.toLowerCase().includes(searchTerm);
        const matchesCategory =
            selectedCategory === "All" || app.category === selectedCategory;
        return matchesSearch && matchesCategory;
    });

    if (filteredApps.length === 0) {
        grid.innerHTML = `<div class="message">No apps found matching your criteria.</div>`;
        return;
    }

    grid.innerHTML = filteredApps
        .map((app) => {
            // Determine the primary store link and button text
            let storeUrl = app.url;
            let storeText = "Get App";

            if (app.source === "playstore") {
                storeUrl = `https://play.google.com/store/apps/details?id=${app.packageName}`;
                storeText = "Play Store";
            } else if (app.source === "fdroid") {
                storeUrl = `https://f-droid.org/packages/${app.packageName}`;
                storeText = "F-Droid";
            }

            // Build the buttons HTML
            let buttonsHtml = `<a href="${storeUrl}" class="card-button" target="_blank" rel="noopener noreferrer">${storeText}</a>`;
            
            // Add the secondary "Visit Website" button if a URL is provided
            if (app.url) {
                buttonsHtml += `<a href="${app.url}" class="card-button secondary" target="_blank" rel="noopener noreferrer">Website</a>`;
            }

            return `
                <div class="card">
                    <span class="card-category">${app.category}</span>
                    <h3 class="card-title">${app.name}</h3>
                    <p class="card-desc">${app.description}</p>
                    <div class="card-actions">
                        ${buttonsHtml}
                    </div>
                </div>
            `;
        })
        .join("");
}

// Boot up the app
loadAppsData();