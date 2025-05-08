library(dplyr)
library(readr)

# Load the data
df <- read_csv("C:\\Users\\shook\\nhl\\Player.csv", locale = locale(encoding = "ISO-8859-1"))

# Ensure 'Position' is a character column (or handle if it's missing)
if (!"Pos" %in% colnames(df)) {
  stop("The dataset does not contain a 'Position' column.")
}

df <- df %>%
  mutate(Pos = as.character(Pos))

# Filter only skaters (forwards and defense)
df_proj <- df %>%
  filter(Pos %in% c("C", "L", "R", "F", "LW", "RW", "D")) %>%
  mutate(
    GPG = G / GP,
    APG = A / GP,
    PPG = P / GP,
    proj_G = round(GPG * 82, 1),
    proj_A = round(APG * 82, 1),
    proj_P = round(PPG * 82, 1)
  ) %>%
  select(Player, Pos, Team, GP, G, A, P, proj_G, proj_A, proj_P) %>%
  arrange(desc(proj_P))

# Save to CSV
write_csv(df_proj, "projected_stats_all_skaters.csv")

# Display top projected players
print(head(df_proj, 10))
