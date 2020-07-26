using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.Data;
using Microsoft.AspNetCore.Hosting;
using System.IO;
using Microsoft.AspNetCore.Http;
using System.Net;
using Microsoft.VisualStudio.Imaging;
using Microsoft.AspNetCore.Mvc;


namespace backendPoSlojevima.DAL
{
    public class SlikeDAL : ISlikeDAL
    {
        private readonly ApplicationDbContext _context;
        private readonly IWebHostEnvironment _IWebHostEnvironment;

        public SlikeDAL(ApplicationDbContext context, IWebHostEnvironment webHostEnvironment)
        {
            _context = context;
            _IWebHostEnvironment = webHostEnvironment;
        }

        

        public void saveImage(PrihvatanjeSlike slika)
        {
            /*  
              var imageDataByteArray = Convert.FromBase64String(image.urlSlike);
              System.IO.File.WriteAllBytes(PathWithFolderName, imageDataByteArray); //saving image in folder
             */
            long  id = _context.slike.Count();
            if (id == 0)
            {
                id = 1;
            }
            else
            {
                id = _context.slike.Max(s => s.id) + 1;
            }
            var urlSlike = "images//image" +  id + ".jpg";  // data.slika.FileName; // + image.id + ".jpg";// data.slika.FileName;
            String webRoot = _IWebHostEnvironment.WebRootPath;
            var PathWithFolderName = System.IO.Path.Combine(webRoot, urlSlike);
            var stream = System.IO.File.Create(PathWithFolderName);
            slika.slika.CopyTo(stream);
        }

        
        public List<Slike> getImages ()
        {
            /* List<String> nizSlika = new List<String>(); //base64
             var images = _context.slike;
             foreach (var image in images)
             {
                var PathWithFolderName = System.IO.Path.Combine(_IWebHostEnvironment.ContentRootPath, image.urlSlike);
                var imageFileStream = File.OpenRead(PathWithFolderName);
             //   byte[] b = File.ReadAllBytes(PathWithFolderName);
              //  var imageBytes = Convert.ToBase64String(b);
              //   nizSlika.Add(imageBytes);
             }

             return nizSlika;*/
            return _context.slike.ToList();
        }

        public void saveOpisSlike(PrihvatanjeOpisaSlike opis)
        {
            Slike image = new Slike();
            image.opis_slike = opis.opis_slike;
            image.x = opis.x;
            image.y = opis.y;
            var id = _context.slike.Count();
            if (id == 0)
            {
                image.id =  1;
            }
            else
            {
                image.id = _context.slike.Max(s => s.id) + 1;
            }
            
            id = _context.objave.Count();
            if (id == 0)
            {
                image.ObjaveID = 1;
            }
            else
            {
                image.ObjaveID = _context.objave.Max(o => o.id);
            }

            image.urlSlike = "images//image" + image.id + ".jpg";
            _context.slike.Add(image);
            _context.SaveChanges();
        }

        public void deleteSlike(List<Slike> slike)
        {
            if (slike != null)
            {
                foreach (var slika in slike)
                {
                    var PathWithFolderName = System.IO.Path.Combine(_IWebHostEnvironment.WebRootPath, slika.urlSlike);
                    if (File.Exists(PathWithFolderName))
                    {
                        File.Delete(PathWithFolderName);
                    }

                }

                _context.slike.RemoveRange(slike);
                _context.SaveChanges();
            }
        }

        public void deleteSliku(Slike slika)
        {
            if (slika != null)
            {
                var PathWithFolderName = System.IO.Path.Combine(_IWebHostEnvironment.WebRootPath, slika.urlSlike);
                if (File.Exists(PathWithFolderName))
                {
                    File.Delete(PathWithFolderName);
                }

                _context.slike.Remove(slika);
                _context.SaveChanges();
            }
        }

        public void izmenaSlike(Slike izmena)
        {
            var slika = _context.slike.FirstOrDefault(s => s.ObjaveID == izmena.ObjaveID);
            if (slika == null) return;
            slika.opis_slike = izmena.opis_slike;
            _context.SaveChanges();
        }
    }
}
