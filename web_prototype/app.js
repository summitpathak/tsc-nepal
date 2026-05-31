/* ==========================================================================
   TSC Nepal Web Prototype - Core Application Logic
   ========================================================================== */

// 1. High-Fidelity Mock Notices (Matching the real scrapers and TSC patterns)
const MOCK_NOTICES = [
  {
    id: "result-secondary-level-2083",
    title: "माध्यमिक तह, तृतीय श्रेणी, शिक्षक पदको खुला प्रतियोगितात्मक लिखित परीक्षाको नतिजा प्रकाशन सम्बन्धी सूचना",
    detailUrl: "/result-secondary-level-2083",
    date: "२०८३/०२/१५",
    imageUrl: "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&q=80&w=600",
    category: "result",
    categoryLabel: "Result (नतिजा)",
    pdfName: "Secondary_Level_Written_Result_2083.pdf",
    description: "शिक्षक सेवा आयोगको निर्णयानुसार मिति २०८३ साल जेठ १५ गते प्रकाशित माध्यमिक तह, तृतीय श्रेणी, शिक्षक पदको खुला प्रतियोगितात्मक लिखित परीक्षाको नतिजा सम्बन्धी विस्तृत विवरण यसै सूचनाद्वारा सबैको जानकारीका लागि प्रकाशन गरिएको छ। लिखित परीक्षामा उत्तीर्ण उम्मेदवारहरूको अन्तर्वार्ता परीक्षा आगामी आषाढ १० गतेदेखि सुरु हुने ब्यहोरा समेत जानकारी गराइन्छ।"
  },
  {
    id: "vacancy-primary-level-2083",
    title: "प्राथमिक तह, तृतीय श्रेणी, शिक्षक पदको खुला तथा समावेशी प्रतियोगितात्मक परीक्षाको विज्ञापन",
    detailUrl: "/vacancy-primary-level-2083",
    date: "२०८३/०२/१०",
    imageUrl: "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?auto=format&fit=crop&q=80&w=600",
    category: "vacancy",
    categoryLabel: "Vacancy (विज्ञापन)",
    pdfName: "Primary_Level_Vacancy_Advertisement_2083.pdf",
    description: "सामुदायिक विद्यालयहरूको प्राथमिक तह, तृतीय श्रेणी, शिक्षक पदमा खुला तथा समावेशी प्रतियोगितात्मक परीक्षाद्वारा स्थायी पदपूर्तिका लागि योग्यता पुगेका नेपाली नागरिकहरूबाट दरखास्त आह्वान गरिन्छ। इच्छुक उम्मेदवारहरूले आयोगको आधिकारिक अनलाइन पोर्टल मार्फत आवेदन दिन सक्नुहुनेछ। दरखास्त बुझाउने अन्तिम मिति २०८३ आषाढ १५ गतेसम्म तोकिएको छ।"
  },
  {
    id: "exam-center-license-2083",
    title: "निम्न माध्यमिक तहको अध्यापन अनुमति पत्र (Teaching License) को परीक्षा केन्द्र निर्धारण सम्बन्धी सूचना",
    detailUrl: "/exam-center-license-2083",
    date: "२०८३/०२/०५",
    imageUrl: "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&q=80&w=600",
    category: "exam",
    categoryLabel: "Exam Center",
    pdfName: "Lower_Sec_License_Exam_Centers_2083.pdf",
    description: "शिक्षक सेवा आयोगद्वारा मिति २०८३ आषाढ ५ गते सञ्चालन हुने निम्न माध्यमिक तहको अध्यापन अनुमति पत्र (Teaching License) को लिखित परीक्षाको परीक्षा केन्द्रहरू सम्बन्धित जिल्लाको विवरण अनुसार तोकिएको व्यहोरा यसै सूचना मार्फत सूचित गरिन्छ। उम्मेदवारहरूले आफ्नो प्रवेश पत्रमा उल्लेखित केन्द्रमा परीक्षा सुरु हुनु भन्दा २ घण्टा अगावै उपस्थित हुनुपर्नेछ।"
  },
  {
    id: "syllabus-lower-secondary-2083",
    title: "निम्न माध्यमिक तह, तृतीय श्रेणी, शिक्षक पदको खुला परीक्षाको परिमार्जित पाठ्यक्रम (Syllabus)",
    detailUrl: "/syllabus-lower-secondary-2083",
    date: "२०८२/१२/२८",
    imageUrl: "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?auto=format&fit=crop&q=80&w=600",
    category: "syllabus",
    categoryLabel: "Syllabus",
    pdfName: "Lower_Secondary_Revised_Syllabus_2083.pdf",
    description: "शिक्षक सेवा आयोगबाट नयाँ शैक्षिक सत्रका लागि निम्न माध्यमिक तह, तृतीय श्रेणी, खुला प्रतियोगितात्मक परीक्षाको पाठ्यक्रम परिमार्जन गरी स्वीकृत गरिएको छ। यो नयाँ पाठ्यक्रम आगामी २०८३ सालको खुला परीक्षादेखि लागू हुनेछ। परिमार्जित पाठ्यक्रममा विषयगत परीक्षा ढाँचा र मूल्याङ्कन परिपाटीमा गरिएका फेरबदलहरू संलग्न फाइलमा स्पष्ट पारिएको छ।"
  },
  {
    id: "result-promotion-performance-2083",
    title: "कार्यसम्पादन मूल्याङ्कनको आधारमा शिक्षक बढुवा नामावली प्रकाशन सम्बन्धी सूचना (कोशी प्रदेश)",
    detailUrl: "/result-promotion-performance-2083",
    date: "२०८३/०२/०१",
    imageUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=600",
    category: "result",
    categoryLabel: "Result (नतिजा)",
    pdfName: "Teacher_Promotion_List_Koshi_2083.pdf",
    description: "शिक्षक सेवा आयोग, बढुवा नियमावली बमोजिम कोशी प्रदेश अन्तर्गतका विभिन्न जिल्लाहरूबाट कार्यसम्पादन मूल्याङ्कनको आधारमा बढुवाका लागि सिफारिस भएका शिक्षकहरूको नामावली सम्बन्धित निर्देशनालयको निर्णयानुसार प्रकाशित गरिएको छ। नतिजामा चित्त नबुझ्ने शिक्षकहरूले यो सूचना प्रकाशित भएको मितिले ३५ दिनभित्र आयोगमा उजुरी दिन सक्नुहुनेछ।"
  },
  {
    id: "vacancy-secondary-license-2082",
    title: "माध्यमिक तहको अध्यापन अनुमति पत्र (Teaching License) परीक्षाको विज्ञापन र अनलाइन आवेदन फारम",
    detailUrl: "/vacancy-secondary-license-2082",
    date: "२०८२/११/१५",
    imageUrl: "https://images.unsplash.com/photo-1427504494785-3a9ca7044f45?auto=format&fit=crop&q=80&w=600",
    category: "vacancy",
    categoryLabel: "Vacancy (विज्ञापन)",
    pdfName: "Sec_License_Exam_Vacancy_2082.pdf",
    description: "माध्यमिक तहको शिक्षक अध्यापन अनुमति पत्र (Teaching License) को परीक्षाका लागि दरखास्त आह्वान गरिएको छ। परीक्षामा सहभागी हुन इच्छुक र न्यूनतम शैक्षिक योग्यता पुगेका उमेदवारहरूले आधिकारिक अनलाइन पोर्टल मार्फत आवेदन फारम भर्न सक्नुहुनेछ। दोब्बर दस्तुर तिरी फारम बुझाउने म्याद सम्बन्धी थप सूचना भित्र संलग्न छ।"
  }
];

// State Management
let currentCategory = "all";
let searchQuery = "";
let currentView = "all"; // "all" or "favorites"
let favorites = JSON.parse(localStorage.getItem("tsc_favorites")) || [];
let currentPage = 1;
const pageSize = 3;

// DOM Elements
const noticesGrid = document.getElementById("notices-grid");
const categoryPills = document.querySelectorAll(".category-pill");
const searchInput = document.getElementById("search-input");
const clearSearchBtn = document.getElementById("clear-search");
const shimmerLoader = document.getElementById("shimmer-loader");
const emptyState = document.getElementById("empty-state");
const pageTitle = document.getElementById("page-title");
const pageSubtitle = document.getElementById("page-subtitle");
const loadMoreContainer = document.getElementById("load-more-container");
const loadMoreBtn = document.getElementById("load-more-btn");

// Sidebar & Navigation Elements
const navAll = document.getElementById("nav-all");
const navFavorites = document.getElementById("nav-favorites");
const mobileFavToggle = document.getElementById("mobile-fav-toggle");

// Modal Elements
const detailModal = document.getElementById("detail-modal");
const closeModalBtn = document.getElementById("close-modal");
const modalCategoryBadge = document.getElementById("modal-category-badge");
const modalTitle = document.getElementById("modal-title");
const modalDate = document.getElementById("modal-date");
const pdfFilename = document.getElementById("pdf-filename");
const modalText = document.getElementById("modal-text");
const downloadBtn = document.getElementById("download-btn");
const favoriteBtn = document.getElementById("favorite-btn");
const shareBtn = document.getElementById("share-btn");

// Theme Toggle Element
const themeToggle = document.getElementById("theme-toggle");

// ==========================================================================
// 2. Render Functions
// ==========================================================================

// Render Grid of Notices with Micro-Animations & Pagination
function renderNotices(isLoadMoreAction = false) {
  if (!isLoadMoreAction) {
    noticesGrid.innerHTML = "";
  }
  
  // Filter by category
  let filtered = MOCK_NOTICES.filter(notice => {
    if (currentCategory !== "all" && notice.category !== currentCategory) {
      return false;
    }
    return true;
  });

  // Filter by search query
  if (searchQuery.trim() !== "") {
    const query = searchQuery.toLowerCase().trim();
    filtered = filtered.filter(notice => 
      notice.title.toLowerCase().includes(query) || 
      notice.date.toLowerCase().includes(query)
    );
  }

  // Filter by view state (Home vs Favorites)
  if (currentView === "favorites") {
    filtered = filtered.filter(notice => favorites.includes(notice.id));
  }

  // Page-based slicing to prevent server-hit layout
  const totalAvailable = filtered.length;
  let paginatedList = filtered;
  
  // Only paginate in home/all mode to represent real server checks
  if (currentView === "all") {
    const visibleCount = currentPage * pageSize;
    paginatedList = filtered.slice(0, visibleCount);
    
    // Toggle Load More button based on remaining data
    if (totalAvailable > visibleCount) {
      loadMoreContainer.style.display = "flex";
    } else {
      loadMoreContainer.style.display = "none";
    }
  } else {
    // Hide pagination in Favorites mode since it is a localized client database
    loadMoreContainer.style.display = "none";
  }

  // Display empty state if no notices match
  if (paginatedList.length === 0) {
    emptyState.style.display = "flex";
    noticesGrid.style.display = "none";
    loadMoreContainer.style.display = "none";
    return;
  }

  emptyState.style.display = "none";
  noticesGrid.style.display = "grid";

  // Build individual cards dynamically
  // If loading more, we only append new items to the DOM to prevent card re-rendering flashes
  const startIndex = isLoadMoreAction ? (currentPage - 1) * pageSize : 0;
  const itemsToAppend = paginatedList.slice(startIndex);

  itemsToAppend.forEach((notice, index) => {
    const isFav = favorites.includes(notice.id);
    const card = document.createElement("div");
    card.className = "notice-card";
    card.style.animation = `slideUp 0.4s ease-out ${index * 0.05}s both`;
    
    card.innerHTML = `
      <div class="card-header-img">
        <img src="${notice.imageUrl}" alt="${notice.title}">
        <span class="card-badge badge-${notice.category}">${notice.categoryLabel}</span>
        <button class="fav-card-btn ${isFav ? 'favorited' : ''}" data-id="${notice.id}" title="Save Notice">
          <i class="${isFav ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
        </button>
      </div>
      <div class="card-body">
        <div class="card-date">
          <i class="fa-regular fa-calendar-days"></i> ${notice.date}
        </div>
        <h3 class="card-title">${notice.title}</h3>
        <div class="card-footer">
          <span class="read-more-text">विवरण हेर्नुहोस् <i class="fa-solid fa-arrow-right"></i></span>
        </div>
      </div>
    `;

    // Click handler for opening the details Modal
    card.addEventListener("click", (e) => {
      if (e.target.closest(".fav-card-btn")) return;
      openDetailsModal(notice);
    });

    // Bookmark/Fav toggle click handler inside card
    const favBtn = card.querySelector(".fav-card-btn");
    favBtn.addEventListener("click", (e) => {
      e.stopPropagation();
      toggleFavorite(notice.id);
      renderNotices();
    });

    noticesGrid.appendChild(card);
  });
}

// ==========================================================================
// 3. Interactivity & State Handlers
// ==========================================================================

// Handle Category Selection changes
categoryPills.forEach(pill => {
  pill.addEventListener("click", () => {
    categoryPills.forEach(p => p.classList.remove("active"));
    pill.classList.add("active");
    
    currentCategory = pill.getAttribute("data-category");
    currentPage = 1; // Reset pagination page to 1 on tab changes
    
    // Simulate web page content skeleton loading transitions
    noticesGrid.style.display = "none";
    loadMoreContainer.style.display = "none";
    shimmerLoader.style.display = "grid";
    
    setTimeout(() => {
      shimmerLoader.style.display = "none";
      renderNotices();
    }, 450);
  });
});

// Search Filtering
searchInput.addEventListener("input", (e) => {
  searchQuery = e.target.value;
  currentPage = 1; // Reset pagination page to 1 on search changes
  if (searchQuery.length > 0) {
    clearSearchBtn.style.display = "block";
  } else {
    clearSearchBtn.style.display = "none";
  }
  renderNotices();
});

// Clear Search bar
clearSearchBtn.addEventListener("click", () => {
  searchInput.value = "";
  searchQuery = "";
  currentPage = 1; // Reset pagination page to 1 on search clear
  clearSearchBtn.style.display = "none";
  renderNotices();
});

// Load More Button Action (Simulates a paginated network request)
loadMoreBtn.addEventListener("click", () => {
  // Prevent double loading
  if (loadMoreBtn.disabled) return;
  
  // Set visual loading state
  loadMoreBtn.disabled = true;
  loadMoreBtn.innerHTML = `<i class="fa-solid fa-spinner fa-spin"></i> सामग्री लोड हुँदैछ... (Loading...)`;
  
  // Simulate network scraper fetch delay for high fidelity experience
  setTimeout(() => {
    currentPage++;
    renderNotices(true); // Render with append mode
    
    // Restore button state
    loadMoreBtn.disabled = false;
    loadMoreBtn.innerHTML = `<i class="fa-solid fa-plus"></i> थप सामग्री लोड गर्नुहोस् (Load More)`;
  }, 600);
});

// Navigation views toggle (Home vs Favorites)
function setViewMode(view) {
  currentView = view;
  
  if (view === "all") {
    navAll.classList.add("active");
    navFavorites.classList.remove("active");
    pageTitle.textContent = "सूचना पार्टी (Notices)";
    pageSubtitle.textContent = "शिक्षक सेवा आयोगका पछिल्ला अपडेटहरू";
    // Enable category section in Home view
    document.querySelector(".category-section").style.display = "block";
  } else {
    navAll.classList.remove("active");
    navFavorites.classList.add("active");
    pageTitle.textContent = "सुरक्षित सूचनाहरू";
    pageSubtitle.textContent = "तपाईंले सुरक्षित राख्नुभएका सूचनाहरू";
    // Hide categories in Saved view to focus purely on favorited items
    document.querySelector(".category-section").style.display = "none";
  }
  renderNotices();
}

navAll.addEventListener("click", (e) => {
  e.preventDefault();
  setViewMode("all");
});

navFavorites.addEventListener("click", (e) => {
  e.preventDefault();
  setViewMode("favorites");
});

mobileFavToggle.addEventListener("click", () => {
  if (currentView === "all") {
    setViewMode("favorites");
    mobileFavToggle.innerHTML = `<i class="fa-solid fa-house"></i>`;
  } else {
    setViewMode("all");
    mobileFavToggle.innerHTML = `<i class="fa-solid fa-bookmark"></i>`;
  }
});

// Persisted Bookmarks logic
function toggleFavorite(id) {
  const index = favorites.indexOf(id);
  if (index === -1) {
    favorites.push(id);
  } else {
    favorites.splice(index, 1);
  }
  localStorage.setItem("tsc_favorites", JSON.stringify(favorites));
}

// ==========================================================================
// 4. Detailed Modal Pop-up Handlers
// ==========================================================================

function openDetailsModal(notice) {
  // Setup modal details dynamically
  modalCategoryBadge.className = `modal-badge badge-${notice.category}`;
  modalCategoryBadge.textContent = notice.categoryLabel;
  modalTitle.textContent = notice.title;
  modalDate.textContent = notice.date;
  pdfFilename.textContent = notice.pdfName;
  modalText.textContent = notice.description;

  // Track button states inside modal
  const isFav = favorites.includes(notice.id);
  updateModalFavBtn(isFav);

  // Remove previous listener to avoid stack build-up
  favoriteBtn.onclick = () => {
    toggleFavorite(notice.id);
    const updatedState = favorites.includes(notice.id);
    updateModalFavBtn(updatedState);
    renderNotices(); // Sync background lists
  };

  // Simulate download PDF actions
  downloadBtn.onclick = () => {
    alert(`प्रविष्टि डाउनलोड सुरु भयो: ${notice.pdfName}\n(Simulated file download of 1.4 MB)`);
  };

  // Share click trigger
  shareBtn.onclick = () => {
    const shareText = `${notice.title} - शिक्षक सेवा आयोग सूचना। थप विवरण: https://tsc.gov.np${notice.detailUrl}`;
    navigator.clipboard.writeText(shareText).then(() => {
      alert("लिङ्क क्लिपबोर्डमा प्रतिलिपि गरियो! (Link copied to clipboard)");
    }).catch(err => {
      alert("लिङ्क सेयर गर्न असमर्थ: " + err);
    });
  };

  // Display Modal with animation
  detailModal.style.display = "flex";
  document.body.style.overflow = "hidden"; // Disable background scrolling
}

function updateModalFavBtn(isFav) {
  if (isFav) {
    favoriteBtn.classList.add("favorited");
    favoriteBtn.innerHTML = `<i class="fa-solid fa-bookmark"></i> सुरक्षित गरिएको`;
  } else {
    favoriteBtn.classList.remove("favorited");
    favoriteBtn.innerHTML = `<i class="fa-regular fa-bookmark"></i> सुरक्षित गर्नुहोस्`;
  }
}

function closeModal() {
  detailModal.style.display = "none";
  document.body.style.overflow = "auto"; // Re-enable background scrolling
}

closeModalBtn.addEventListener("click", closeModal);
detailModal.addEventListener("click", (e) => {
  if (e.target === detailModal) closeModal();
});

// Escape key to close modal
document.addEventListener("keydown", (e) => {
  if (e.key === "Escape" && detailModal.style.display === "flex") {
    closeModal();
  }
});

// ==========================================================================
// 5. Light / Dark Theme Switching Logic
// ==========================================================================

const activeTheme = localStorage.getItem("tsc_theme") || "light";
setTheme(activeTheme);

themeToggle.addEventListener("click", () => {
  const newTheme = document.body.classList.contains("light-mode") ? "dark" : "light";
  setTheme(newTheme);
});

function setTheme(theme) {
  if (theme === "dark") {
    document.body.className = "dark-mode";
    themeToggle.innerHTML = `<i class="fa-solid fa-sun" style="color: var(--gold-accent);"></i>`;
    localStorage.setItem("tsc_theme", "dark");
  } else {
    document.body.className = "light-mode";
    themeToggle.innerHTML = `<i class="fa-solid fa-moon"></i>`;
    localStorage.setItem("tsc_theme", "light");
  }
}

// ==========================================================================
// 6. Application Boot
// ==========================================================================
window.addEventListener("DOMContentLoaded", () => {
  // Simulate Initial skeleton loads for high premium feel
  shimmerLoader.style.display = "grid";
  noticesGrid.style.display = "none";

  setTimeout(() => {
    shimmerLoader.style.display = "none";
    renderNotices();
  }, 800);
});
