# 🧠 Brain Tumor Detection using MRI Images (MATLAB Project)

Branch: Electronics and Communication Engineering (ECI)
Semester: 5th
Course: Digital Image Processing

## 📘 Project Overview

This project implements a MATLAB-based system for detecting brain tumors in MRI images.
It includes preprocessing, skull stripping, segmentation, and performance evaluation steps.

The project features a custom MATLAB GUI (`brain_tumor_gui.m`) that visually displays:
- The original MRI image
- Denoised output
- Skull-stripped image
- Segmented tumor region
- Computed performance metrics

## ⚙️ Workflow Pipeline

Input MRI Image → Preprocessing (Denoising) → Skull Stripping → Segmentation (FCM / K-Means) → Postprocessing → Performance Evaluation → GUI Visualization

## 🧩 Key Features

🧼 Preprocessing: Noise removal using Median or Gaussian filters  
💀 Skull Stripping: Threshold-based morphological operations  
🎯 Segmentation: Fuzzy C-Means (FCM) or K-Means clustering  
📊 Evaluation: Precision, Recall, F1-score, Accuracy, Dice coefficient  
🖥️ MATLAB GUI: Visualizes all steps and outputs results in real-time  

## 🧠 Dataset

Supported datasets:
- Kaggle: Brain MRI Images for Brain Tumor Detection  
  https://www.kaggle.com/navoneel/brain-mri-images-for-brain-tumor-detection  
- Figshare: Brain Tumor MRI Dataset  
  https://figshare.com/articles/dataset/brain_tumor_dataset/1512427  

## 💻 Software Requirements

MATLAB R2017a or later  
Image Processing Toolbox  
Fuzzy Logic Toolbox (for FCM clustering)

## 🧮 Algorithm (Step-by-Step)

Step 1 — Input MRI Image  
Load MRI scan using MATLAB’s uigetfile.

Step 2 — Preprocessing  
Apply Median filter to remove salt & pepper noise.
```matlab
I = imread('sample_mri.jpg');
denoise_img = medfilt2(rgb2gray(I), [3 3]);
