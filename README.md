# _ScholarImpact_
A bibliometric tool to analyse, visualise, and share your research impact, output and scholarly influence using Google Scholar and OpenAlex data.

For each article under your Google Scholar Profile, **_ScholarImpact_**: (1) total number of citations, (2) number of unique authors who have cited the article, (3) number of countries from which citations originate, (4) number of institutions from which citations originate, (5) geographic distribution of citations, (6) citation trends over time, (7) research domain analysis, (8) interdisciplinary impact Metrics including Patents and Wikipedia mentions (9) Alternative metrics.

![Example Dashboard](https://static.abhishek-tiwari.com/scholarimpact/example-dashboard-v4.png)

![Example Dashboard](https://static.abhishek-tiwari.com/scholarimpact/geo-trends-v4.png)

![Research Domains Analysis](https://static.abhishek-tiwari.com/scholarimpact/research-domains-v4.png)

## Workflow Overview
This workflow first extracts author data from your Google Scholar profile and optionally enriches it with OpenAlex and Altmetric data. Then it sources citations for each article under your Google Scholar profile. Next workflow enriches them with information using Google Scholar profiles of citing authors and/or OpenAlex APIs. Finally, output data is used to present your impact of your research with geographic and institutional insights.


```mermaid
flowchart TD
    A[Your Google Scholar Profile] --> B[Your Articles]
    B --> C[OpenAlex API]
    B --> D[Altmetric API]
    C --> E[Enhanced Scholar Data]
    D --> E[Enhanced Scholar Data]

    style A fill:#0ea5e9,stroke:#0ea5e9,color:#ffffff
    style C fill:#059669,stroke:#059669,color:#ffffff
    style D fill:#059669,stroke:#059669,color:#ffffff
    style E fill:#ecebe3,stroke:#ecebe3,color:#3d3a2a
```

```mermaid
flowchart TD
    A[Enhanced Scholar Data] --> B[Your Articles]
    B --> C[Citing Articles]
    B --> F[OpenAlex API]
    C --> D[Enhanced Citation Data]
    D --> E[Streamlit Dashboard]

    C --> F[OpenAlex API]
    C --> G[Google Scholar Profiles of citing Authors]
    F --> D
    G --> D

    F -.-> H[Author Affiliations]
    F -.-> I[Country Codes]
    F -.-> J[Research Domains]
    G -.-> K[Verified Email Domain]
    G -.-> L[Profile Details including Affiliations]

    H --> D
    I --> D
    J --> D
    K --> D
    L --> D

    style A fill:#ecebe3,stroke:#ecebe3,color:#3d3a2a
    style E fill:#cb785c,stroke:#cb785c,color:#ffffff
    style F fill:#059669,stroke:#059669,color:#ffffff
    style G fill:#fbbf24,stroke:#fbbf24,color:#3d3a2a
    style D fill:#ecebe3,stroke:#ecebe3,color:#3d3a2a
```

## Quick Start

### Prerequisites

Install [mise](https://mise.jdx.dev) to manage CLI tools (`uv`, `just`):

```bash
curl https://mise.run | sh
# Restart your shell, then verify
mise --version
```

```bash
# Clone the repo
git clone https://github.com/abhishektiwari/scholarimpact.git
cd scholarimpact

# Install Python, uv, and just
mise install

# Install dependencies
just install
```


## Caution
This system is designed for academic research purposes and personal usage. Please use responsibly and in accordance with Google Scholar, OpenAlex, Altmetric terms of services with appropriate attribution.

## Development Setup

Follow the Prerequisites steps above, then:

```bash
just --list   # see all available commands

just format   # format code with ruff
just lint     # lint with ruff + mypy
just test     # run pytest with coverage
just check    # format + lint + test
just build    # build wheel and sdist
```

## Step-by-Step Guide

### Option 1: For Deployment (Recommended)

This approach creates a standalone project suitable for deployment to Streamlit Cloud or local development.

#### Step 1: Generate Dashboard Project

```bash
uv run scholarimpact generate-dashboard --output-dir my-research-dashboard --name app.py
cd my-research-dashboard
```

This creates a complete project structure with `app.py`, `requirements.txt`, `.streamlit/config.toml`, and a `static` folder containing fonts used by default theme.

#### Step 2: Extract Author Publications

```bash
# Find your Scholar ID in your profile URL:
# https://scholar.google.com/citations?user=YOUR_SCHOLAR_USER_ID

uv run scholarimpact extract-author "YOUR_SCHOLAR_USER_ID" --openalex-email your.email@example.com
```

This creates `data/author.json` with your publication list, enriched with OpenAlex and Altmetric metrics by default.

#### Step 3: Crawl Citation Data

```bash
uv run scholarimpact crawl-citations data/author.json --openalex-email your.email@example.com
```

This creates `data/cites-{ID}.json` files for each publication.

#### Step 4: Test Locally

```bash
streamlit run app.py
```

Open `http://localhost:8501` to view your dashboard.

#### Step 5: Push to GitHub

```bash
git init
git add .
git commit -m "Initial research dashboard"

git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git branch -M main
git push -u origin main
```

#### Step 6: Deploy on Streamlit Cloud

1. Go to [share.streamlit.io](https://share.streamlit.io)
2. Click "New app"
3. Connect your GitHub account
4. Select your repository and branch
5. Set main file path: `app.py` (or your custom name)
6. Click "Deploy"

#### Step 7: Project Structure for Deployment

Your repository should contain:
```
my-research-dashboard/
├── app.py                    # Main dashboard file
├── requirements.txt          # Python dependencies
├── .streamlit/
│   └── config.toml          # Streamlit configuration
├── static/                  # Static assets (fonts from scholarimpact/assets/fonts)
│   ├── SpaceGrotesk-SemiBold.ttf
│   ├── SpaceGrotesk-VariableFont_wght.ttf
│   ├── SpaceMono-Regular.ttf
│   ├── SpaceMono-Bold.ttf
│   ├── SpaceMono-Italic.ttf
│   ├── SpaceMono-BoldItalic.ttf
│   └── OFL-*.txt           # Font licenses
└── data/
    ├── author.json          # Author profile data
    └── cites-*.json         # Citation data files
```

#### Step 8: Update Data

To update citation data:

1. Re-run steps 2 and 3 to refresh data files
2. Commit and push to your GitHub repository
3. Streamlit Cloud will automatically detect changes and restart the app

#### Tips for Streamlit Cloud Deployment

- Keep data files under 100MB each for optimal performance
- Use `.gitignore` to exclude unnecessary files
- Set secrets in Streamlit Cloud settings if needed
- Monitor app logs in Streamlit Cloud dashboard for debugging

### Option 2: For Quick Local Testing

This approach is fastest for local analysis without deployment needs.

#### Step 1: Extract Author Publications

```bash
uv run scholarimpact extract-author "YOUR_SCHOLAR_USER_ID" --openalex-email your.email@example.com
```

#### Step 2: Crawl Citation Data

```bash
uv run scholarimpact crawl-citations data/author.json --openalex-email your.email@example.com
```

#### Step 3: Launch Dashboard

```bash
uv run ScholarImpact
```

The dashboard opens at `http://localhost:8501`.

## CLI Options Reference

### `scholarimpact extract-author` Command

Extract author publications from Google Scholar with OpenAlex and Altmetric enrichment:

```bash
uv run scholarimpact extract-author [OPTIONS] SCHOLAR_ID
```

Arguments:
- `SCHOLAR_ID`: Google Scholar author ID or full profile URL

Options:
| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `--max-papers N` | int | None | Maximum number of papers to analyze (default: all) |
| `--delay X` | float | 2.0 | Delay between requests in seconds |
| `--output-dir DIR` | str | ./data | Output directory for author.json |
| `--output-file FILE` | str | None | Custom output file path (overrides output-dir) |
| `--use-openalex/--no-openalex` | flag | True | Enable OpenAlex enrichment (default: enabled) |
| `--openalex-email EMAIL` | str | None | Email for OpenAlex API (optional, for higher rate limits) |
| `--use-altmetric/--no-altmetric` | flag | True | Enable Altmetric enrichment (requires OpenAlex, default: enabled) |

OpenAlex enrichment adds (all fields prefixed with `openalex_`):
- `openalex_ids`: Object containing all identifiers:
  - `openalex`: OpenAlex work URL
  - `doi`: Digital Object Identifier URL
  - `mag`: Microsoft Academic Graph ID
  - `pmid`: PubMed ID URL
- `openalex_type`: Publication type (article, book, etc.)
- `openalex_citation_normalized_percentile`: Percentile ranking of citations
- `openalex_cited_by_percentile_year`: Citation percentile by year
- `openalex_fwci`: Field-Weighted Citation Impact
- `openalex_cited_by_count`: OpenAlex citation count
- `openalex_primary_topic`: Main research topic
- `openalex_domain`, `openalex_field`, `openalex_subfield`: Hierarchical classification

Altmetric enrichment adds (all fields prefixed with `altmetric_`):
- `altmetric_score`: Overall Altmetric attention score
- `altmetric_cited_by_wikipedia_count`: Citations in Wikipedia
- `altmetric_cited_by_patents_count`: Citations in patents
- `altmetric_cited_by_accounts_count`: Social media accounts mentioning
- `altmetric_cited_by_posts_count`: Social media posts mentioning
- `altmetric_scopus_subjects`: Scopus subject classifications
- `altmetric_readers`: Reader counts by platform (Mendeley, CiteULike, etc.)
- `altmetric_readers_count`: Total reader count
- `altmetric_images`: Altmetric badge images (small, medium, large)
- `altmetric_details_url`: Link to detailed Altmetric page

Examples:
```bash
# Basic usage (OpenAlex and Altmetric enabled by default)
uv run scholarimpact extract-author "ABC123DEF"

# With email for higher OpenAlex rate limits
uv run scholarimpact extract-author "ABC123DEF" --openalex-email your.email@example.com

# Disable Altmetric enrichment (keep OpenAlex)
uv run scholarimpact extract-author "ABC123DEF" --no-altmetric

# Disable all enrichment (Google Scholar only)
uv run scholarimpact extract-author "ABC123DEF" --no-openalex --no-altmetric

# Limit to first 20 papers with 3-second delays
uv run scholarimpact extract-author "ABC123DEF" --max-papers 20 --delay 3

# Custom output file
uv run scholarimpact extract-author "ABC123DEF" --output-file data/my_author.json --openalex-email your.email@example.com

# Full URL format
uv run scholarimpact extract-author "https://scholar.google.com/citations?user=ABC123DEF"
```

### `scholarimpact crawl-citations` Command

Crawl citations with OpenAlex integration:

```bash
uv run scholarimpact crawl-citations [OPTIONS] AUTHOR_JSON
```

Arguments:
- `AUTHOR_JSON`: Path to author.json file containing publications

Options:
| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `--openalex-email EMAIL` | str | None | Email for OpenAlex API (higher rate limits) |
| `--max-citations N` | int | None | Maximum citations per paper |
| `--delay-min X` | float | 5.0 | Minimum delay between requests (seconds) |
| `--delay-max Y` | float | 10.0 | Maximum delay between requests (seconds) |
| `--output-dir DIR` | str | None | Output directory (defaults to author.json directory) |

Examples:
```bash
# Basic usage with OpenAlex
uv run scholarimpact crawl-citations data/author.json --openalex-email me@university.edu

# Custom delays
uv run scholarimpact crawl-citations data/author.json --delay-min 3 --delay-max 8

# Custom output directory
uv run scholarimpact crawl-citations data/author.json --output-dir custom_data

# Limit citations per paper
uv run scholarimpact crawl-citations data/author.json --max-citations 100
```

### `ScholarImpact` Command

Launch the interactive dashboard:

```bash
uv run ScholarImpact [OPTIONS]
```

Options:
| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `--port N` | int | 8501 | Port to run the dashboard on |
| `--address ADDR` | str | localhost | Address to bind the server to |
| `--data-dir DIR` | str | ./data | Directory containing citation data files |

Examples:
```bash
uv run ScholarImpact                        # basic usage
uv run ScholarImpact --port 8502            # custom port
uv run ScholarImpact --address 0.0.0.0     # external access
uv run ScholarImpact --data-dir custom_data # different data directory
```

### `scholarimpact quick-start` Command

Complete analysis pipeline from Scholar ID to dashboard:

```bash
uv run scholarimpact quick-start [OPTIONS] SCHOLAR_ID
```

Arguments:
- `SCHOLAR_ID`: Google Scholar author ID or full profile URL

Options:
| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `--openalex-email EMAIL` | str | None | OpenAlex email for enhanced data |
| `--output-dir DIR` | str | ./data | Output directory for all data |
| `--launch-dashboard/--no-dashboard` | flag | True | Launch dashboard after analysis |

Examples:
```bash
uv run scholarimpact quick-start "ABC123DEF" --openalex-email me@university.edu
uv run scholarimpact quick-start "ABC123DEF" --no-dashboard
uv run scholarimpact quick-start "ABC123DEF" --output-dir results
```

### `scholarimpact generate-dashboard` Command

Generate a standalone dashboard project for deployment to Streamlit Cloud:

```bash
uv run scholarimpact generate-dashboard [OPTIONS]
```

Options:
| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `--output-dir DIR` | str | . | Output directory for generated files |
| `--name FILE` | str | my_dashboard.py | Name of the dashboard file |
| `--data-dir DIR` | str | ./data | Data directory path for dashboard |
| `--title TEXT` | str | My Citation Dashboard | Dashboard title |

Examples:
```bash
uv run scholarimpact generate-dashboard
uv run scholarimpact generate-dashboard --output-dir my-project --title "Research Impact Analysis"
uv run scholarimpact generate-dashboard --data-dir ../citation_data --name app.py
```

This command generates:

- A dashboard Python file (default: `my_dashboard.py`)
- `.streamlit/config.toml` with theme configuration
- `requirements.txt` for deployment
- `static` folder containing fonts used by default theme

## Citation

[![zenodo.17282762](https://zenodo.org/badge/DOI/10.5281/zenodo.17282708.svg)](https://doi.org/10.5281/zenodo.17282708)

If you use ScholarImpact in your research, please cite it as:

```bibtex
@software{tiwari_2025_17282762,
  author       = {Tiwari, Abhishek},
  title        = {ScholarImpact: A Python tool to analyse, visualise, and share individual research impact, output and scholarly influence using bibliometric data},
  month        = oct,
  year         = 2025,
  publisher    = {Zenodo},
  doi          = {10.5281/zenodo.17282708},
  url          = {https://doi.org/10.5281/zenodo.17282708},
}
```

**APA Format:**
```
Tiwari, A. (2025). ScholarImpact: A Python tool to analyse, visualise, and share individual research impact, output and scholarly influence using bibliometric data. Zenodo. https://doi.org/10.5281/zenodo.17282708
```

**MLA Format:**
```
Tiwari, A. ScholarImpact: A Python tool to analyse, visualise, and share individual research impact, output and scholarly influence using bibliometric data. Zenodo, 7 Oct. 2025, https://doi.org/10.5281/zenodo.17282708.
```
