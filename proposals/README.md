## Put stylesheet examples here.

What should teacup actually do?

(features that most proposals contain)

1. Provide a clean API to make views pretty.

2. Provide a way to share design configuration throughout the app.

What could teacup also do?

(features that some proposals include)

3. Provide assistance for automatically laying out sub-views (farcaller_layout)

4. Provide assistance for automatically instantiating sub-views (stylesheet_by_conradirwin)

5. Provide a clean API around animations (teacup_by_colinta)


I suggest we build something that implements 1. and 2. in such a way that 3., 4., and 5. can
easily be added (either to teacup itself, or using an external library).
