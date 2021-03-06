## ----ggplot2setup, include=FALSE, eval=TRUE, cache=FALSE-------------------------------------------
knitr::opts_chunk$set(eval=T, echo=T)


## ----layer, eval=FALSE-----------------------------------------------------------------------------
## # recall that starwars is in the dplyr package
## ggplot(aes(x = height, y = mass), data = starwars)


## ----layer2----------------------------------------------------------------------------------------
ggplot(aes(x = height, y = mass), data = starwars) +
  geom_point()


## ----layer3----------------------------------------------------------------------------------------
ggplot(aes(x = height, y = mass), data = starwars) +
  geom_point(color = 'white') +
  labs(x = 'Height in cm', y = 'Weight in kg') +
  theme_dark()


## ----pipeplus, eval=FALSE--------------------------------------------------------------------------
## ggplot(aes(x = myvar, y = myvar2), data = mydata) +
##   geom_point()


## ----aes, eval=F-----------------------------------------------------------------------------------
## aes(
##   x = myvar,
##   y = myvar2,
##   color = myvar3,
##   group = g
## )


## ----aes_vs_not1, eval=FALSE-----------------------------------------------------------------------
## ... +
##   geom_point(..., size = 4)


## ----aes_vs_not2, eval=FALSE-----------------------------------------------------------------------
## ... +
##   geom_point(aes(size = myvar))


## ----ggscatter, dev='png'--------------------------------------------------------------------------
library(ggplot2)

data("diamonds")

data('economics')

ggplot(aes(x = carat, y = price), data = diamonds) +
  geom_point(size = .5, color = 'peru')


## ----ggline----------------------------------------------------------------------------------------
ggplot(aes(x = date, y = unemploy), data = economics) +
  geom_line() +
  geom_text(
    aes(label = unemploy),
    vjust = -.5,
    data = filter(economics, date == '2009-10-01')
  )


## ----ggalpha, fig.width=6, fig.height=4, dev='png'-------------------------------------------------
ggplot(aes(x = carat, y = price), data = diamonds) +
  geom_point(aes(size = carat, color = clarity), alpha = .05) 


## ----key_glyphs------------------------------------------------------------------------------------
ggplot(aes(x = carat, y = price), data = diamonds %>% sample_frac(.01)) +
  geom_point(aes(size = carat, color = clarity), key_glyph = "vpath")


## ----ggquant---------------------------------------------------------------------------------------
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_quantile()


## ----ggsmooth--------------------------------------------------------------------------------------
data(mcycle, package = 'MASS')

ggplot(aes(x = times, y = accel), data = mcycle) +
  geom_point() +
  geom_smooth(formula = y ~ s(x, bs = 'ad'), method = 'gam')


## ----ggstatsum-------------------------------------------------------------------------------------
ggplot(mtcars, aes(cyl, mpg)) +
  geom_point() +
  stat_summary(
    fun.data = "mean_cl_boot",
    colour = "orange",
    alpha = .75,
    size = 1
  )


## ----scale_labs------------------------------------------------------------------------------------
ggplot(aes(x = times, y = accel), data = mcycle) +
  geom_smooth(se = FALSE) +
  labs(
    x     = 'milliseconds after impact', 
    y     = 'head acceleration', 
    title = 'Motorcycle Accident'
  )


## ----scale_lims------------------------------------------------------------------------------------
ggplot(mpg, aes(x = displ, y = hwy, size = cyl)) +
  geom_point() +
  ylim(c(0, 60))

ggplot(mpg, aes(x = displ, y = hwy, size = cyl)) +
  geom_point() +
  scale_y_continuous(
    limits = c(0, 60),
    breaks = seq(0, 60, by = 12),
    minor_breaks = seq(6, 60, by = 6)
  )


## ----scale_size2-----------------------------------------------------------------------------------
ggplot(mpg, aes(x = displ, y = hwy, size = cyl)) +
  geom_point() +
  scale_size(range = c(1, 3))


## ----scale_color-----------------------------------------------------------------------------------
ggplot(mpg, aes(x = displ, y = hwy, color = cyl)) +
  geom_point() +
  scale_color_gradient2()

ggplot(mpg, aes(x = displ, y = hwy, color = factor(cyl))) +
  geom_point() +
  scale_color_manual(values = c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728"))


## ----scale_scale-----------------------------------------------------------------------------------
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  scale_x_log10()


## ----facetgrid, eval=1, echo=1---------------------------------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_point() +
  facet_grid(~ cyl)

ggplot(mpg, aes(displ, cty)) + 
  geom_point() +
  facet_grid(~ cyl, labeller = label_both)

ggplot(midwest, aes(popdensity, percbelowpoverty)) + 
  geom_point() +
  facet_grid(~ state, labeller = label_both)


## ----facetgrid2------------------------------------------------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_point() +
  facet_grid(vs ~ cyl, labeller = label_both)


## ----facetwrap-------------------------------------------------------------------------------------
ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_point() +
  facet_wrap(vs ~ cyl, labeller = label_both, ncol=2)


## ----patchwork-------------------------------------------------------------------------------------
library(patchwork)

g1 = ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_point()

g2 = ggplot(mtcars, aes(wt)) + 
  geom_density()

g3 = ggplot(mtcars, aes(mpg)) + 
  geom_density()

g1 /                       # initial plot, place next part underneath
  (g2 | g3)                # groups g2 and g3 side by side


## ----patchwork2------------------------------------------------------------------------------------
p1 = ggplot(mtcars) + geom_point(aes(mpg, disp))
p2 = ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear))
p3 = ggplot(mtcars) + geom_smooth(aes(disp, qsec))
p4 = ggplot(mtcars) + geom_bar(aes(carb))
p5 = ggplot(mtcars) + geom_violin(aes(cyl, mpg, group = cyl))

p1 +
  p2 +
  (p3 / p4) * theme_void() +
  p5 +
  plot_layout(widths = c(2, 1))


## ----finecontrol, fig.height=6, fig.width=8, echo=-c(1:5, 7), dev='png'----------------------------
library(grid); library(caTools)
img = caTools::read.gif('img/lamb.gif')
lambosun = img$col[img$image+1]
dim(lambosun) = dim(img$image)

ggplot(aes(x = carat, y = price), data = diamonds) +
  annotation_custom(
    rasterGrob(
      lambosun,
      width = unit(1, "npc"),
      height = unit(1, "npc"),
      interpolate = FALSE
    ),-Inf,
    Inf,
    -Inf,
    Inf
  ) +
  geom_point(aes(color = clarity), alpha = .5) +
  scale_y_log10(breaks = c(1000, 5000, 10000)) +
  xlim(0, 10) +
  scale_color_brewer(type = 'div') +
  facet_wrap( ~ cut, ncol = 3) +
  theme_minimal() +
  theme(
    axis.ticks.x = element_line(color = 'darkred'),
    axis.text.x = element_text(angle = -45),
    axis.text.y = element_text(size = 20),
    strip.text = element_text(color = 'forestgreen'),
    strip.background = element_blank(),
    panel.grid.minor = element_line(color = 'lightblue'),
    legend.key = element_rect(linetype = 4),
    legend.position = 'bottom'
  )


## ----gganimate, eval=FALSE-------------------------------------------------------------------------
## library(gganimate)
## 
## load('data/gapminder.RData')
## 
## gap_plot = gapminder_2019 %>%
##   filter(giniPercap != 40)
## 
## gap_plot_filter = gap_plot %>%
##   filter(country %in% c('United States', 'Mexico', 'Canada'))
## 
## initial_plot = ggplot(gap_plot, aes(x = year, y = giniPercap, group = country)) +
##   geom_line(alpha = .05) +
##   geom_path(
##     aes(color = country),
##     lwd = 2,
##     arrow = arrow(
##       length = unit(0.25, "cm")
##     ),
##     alpha = .5,
##     data = gap_plot_filter,
##     show.legend = FALSE
##   ) +
##   geom_text(
##     aes(color = country, label = country),
##     nudge_x = 5,
##     nudge_y = 2,
##     size = 2,
##     data = gap_plot_filter,
##     show.legend = FALSE
##   ) +
##   theme_clean() +
##   transition_reveal(year)
## 
## animate(initial_plot, end_pause = 50, nframes = 150, rewind = TRUE)


## ----anim-save, echo=FALSE, eval=FALSE-------------------------------------------------------------
## anim_save('img/gini_animate.gif')


## ----ggplot_ex1, echo=FALSE------------------------------------------------------------------------
library(ggplot2)
ggplot(aes(x=waiting, y=eruptions), data=faithful) +
  geom_point()


## ----ggplot_ex2------------------------------------------------------------------------------------
library(maps)
mi = map_data("county", "michigan")
seats = mi %>% 
  group_by(subregion) %>% 
  summarise_at(vars(lat, long), function(x) median(range(x)))

# inspect the data
# head(mi)
# head(seats)

ggplot(mi, aes(long, lat)) +
  geom_polygon(aes(group = subregion), fill = NA, colour = "grey60") +
  geom_text(aes(label = subregion), data = seats, size = 1, angle = 45) +
  geom_point(x=-83.748333, y=42.281389, color='#1e90ff', size=3) +
  theme_minimal() +
  theme(panel.grid=element_blank())

