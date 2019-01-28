// Remove slices and X values / columns and reslice from top
//
// As done in the leaf trait analysis python program. This is to prepare the
// original image (either Gridrec or Phase contrast / paganin) to match it to
// the trimmed segemented image in order to match stomata positions. This will
// allow to draw each stoma on the segmented image in ImageJ in order to run the
// analysis carried out in Earles et al. (2018).

// J. Mason Earles, Guillaume Theroux-Rancourt, Adam B. Roddy, Matthew E. Gilbert,
// Andrew J. McElrone, Craig R. Brodersen (2018) Beyond Porosity: 3D Leaf
// Intercellular Airspace Traits That Impact Mesophyll Conductance. Plant
// Physiology, 178 (1) 148-162; DOI: 10.1104/pp.18.00550

// Author: Guillaume Théroux-Rancourt (guillaume.theroux-rancourt@boku.ac.at)
// Created on 28.01.2019
// Last modification on 28.01.2019

fullIMG = getTitle();
getPixelSize(unit, pw, ph, pd);


run("Delete Slice Range", "first=1841 last=1920");
run("Delete Slice Range", "first=1 last=80");
run("Canvas Size...", "width=2364 height=770 position=Center zero");

run("Reslice [/]...", "output="+pw+" start=Top avoid");
