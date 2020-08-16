using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Data;
using backendPoSlojevima.Models;
using Microsoft.AspNetCore.Hosting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.IO;
using Microsoft.AspNetCore.Http;
using System.Net;
using Microsoft.VisualStudio.Imaging;
using Microsoft.AspNetCore.Mvc;
using System.Data.Entity;

namespace backendPoSlojevima.DAL
{
    public class KomentariDAL : IKomentariDAL
    {
        private readonly ApplicationDbContext _context;
        private readonly IWebHostEnvironment _IWebHostEnvironment;
        private readonly IObavestenjaDAL _IObavestenjaDAL;

        public KomentariDAL(ApplicationDbContext context, IWebHostEnvironment IWebHostEnvironment, IObavestenjaDAL IObavestenjaDAL)
        {
            _context = context;
            _IWebHostEnvironment = IWebHostEnvironment;
            _IObavestenjaDAL = IObavestenjaDAL;
        }

        public void deleteKomentare(List<Komentari> komentari)
        {
            if (komentari != null)
            {
                foreach (var komentar in komentari)
                {
                    if (komentar.urlSlike != null)
                    {
                        var PathWithFolderName = System.IO.Path.Combine(_IWebHostEnvironment.WebRootPath, komentar.urlSlike);
                        if (File.Exists(PathWithFolderName))
                        {
                            File.Delete(PathWithFolderName);
                        }
                     }
                    _IObavestenjaDAL.removeKomentar(komentar);
                }
              
                _context.komentari.RemoveRange(komentari);
                _context.SaveChanges();
            }
        }

        public void deleteKomentar(Komentari komentar,int ind)
        {
            if (komentar != null)
            {
                if (ind == 1) komentar.korisnik.poeni -= 10;
                  else komentar.korisnik.poeni -= 1;
                if (komentar.korisnik.poeni < 0) komentar.korisnik.poeni = 0;
                if (komentar.urlSlike != null)
                    {
                        var PathWithFolderName = System.IO.Path.Combine(_IWebHostEnvironment.WebRootPath, komentar.urlSlike);
                        if (File.Exists(PathWithFolderName))
                        {
                            File.Delete(PathWithFolderName);
                        }

                    }
                _IObavestenjaDAL.removeKomentar(komentar);
                _context.komentari.RemoveRange(komentar);
                _context.SaveChanges();
            }
        }


        public List<Komentari> getAllReseneProbleme()
        {
            return _context.komentari.Where(k => k.resenProblem == 1).ToList();
        }
        public List<Komentari> getAllKomentari()
        {
            return _context.komentari.Include(k => k.objave ).Include(k=> k.korisnik).ToList();
        }

        public void saveImage(PrihvatanjeSlikeKomentara image)
        {
            long id = _context.komentari.Count();
            if (id == 0)
            {
                 id = 1;
            }
           else
           {
              id = _context.komentari.Max(o => o.id) + 1;
           }
           var  urlSlike = "komentari//images//image" + id + ".jpg";
           var PathWithFolderName = System.IO.Path.Combine(_IWebHostEnvironment.WebRootPath, urlSlike);
           var stream = System.IO.File.Create(PathWithFolderName);
           image.slika.CopyTo(stream);

        }

        public void saveKomentar(PrihvatanjeKomentara data,int poslataSlika,int resenProblem)
        {
          /*  if (resenProblem == 1)
            {
                ReseniProblemi problem = new ReseniProblemi();
                problem.idKorisnika = data.idKorisnika;
                problem.idObjave = data.idObjave;
                problem.tekst = data.tekst;
                var id = _context.reseni_problemi.Count();
                if (id == 0)
                {
                    problem.id = _context.reseni_problemi.Count() + 1;
                }
                else
                {
                    problem.id = _context.reseni_problemi.Max(o => o.id) + 1;
                }
                if (poslataSlika == 1)
                {
                    problem.urlSlike = "reseniProblemi//images//image" + problem.id + ".jpg";
                }
                else
                {
                    problem.urlSlike = null;
                }

                _context.reseni_problemi.Add(problem);


            }
            else*/
            
                Komentari komentar = new Komentari();
                komentar.KorisnikID = data.idKorisnika;
                komentar.ObjaveID = data.idObjave;
                komentar.tekst = data.tekst;
                komentar.resenProblem = data.resenProblem;
                komentar.oznacenKaoResen = data.oznacenKaoResen;
                var id = _context.komentari.Count();
                if (id == 0)
                {
                    komentar.id = 1;
                }
                else
                {
                    komentar.id = _context.komentari.Max(o => o.id) + 1;
                }
                if (poslataSlika == 1)
                {
                    komentar.urlSlike = "komentari//images//image" + komentar.id + ".jpg";
                }
                else
                {
                    komentar.urlSlike = null;
                }

                _context.komentari.Add(komentar);

            _IObavestenjaDAL.dodajKomentar(komentar);
            _context.SaveChanges();

        }

        public Komentari problemResen(Komentari komentar)
        {
            if (komentar.oznacenKaoResen == 1)
            {
                komentar.korisnik.poeni += 20;
                komentar.objave.korisnik.poeni += 10;
                komentar.resenProblem += 1;
                _context.komentari.Update(komentar);
                /* ReseniProblemi problem = new ReseniProblemi();
                 problem.idKorisnika = komentar.idKorisnika;
                 problem.idObjave = komentar.idObjave;
                 problem.tekst = komentar.tekst;
                 problem.urlSlike = komentar.urlSlike;
                 var id = _context.reseni_problemi.Count();
                 if (id == 0)
                 {
                     problem.id = 1;
                 }
                 else
                 {
                     problem.id = _context.reseni_problemi.Max(o => o.id) + 1;
                 }

                 _context.reseni_problemi.Add(problem);*/
                _context.SaveChanges();
                return komentar;
            }
            return null;
        }

        public int saveResenjeInstitucije(PrihvatanjeResenihProbelma slika)
        {
            Komentari komentar = new Komentari();
            var imageDataByteArray = Convert.FromBase64String(slika.base64);
            komentar.KorisnikID = slika.idInstitucije;
            komentar.ObjaveID = slika.idObjave;
            komentar.urlSlike = "komentari//images//image" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + ".jpg";  // data.slika.FileName; // + image.id + ".jpg";// data.slika.FileName;
            String webRoot = _IWebHostEnvironment.WebRootPath;
            var PathWithFolderName = System.IO.Path.Combine(webRoot, komentar.urlSlike);
            System.IO.File.WriteAllBytes(PathWithFolderName, imageDataByteArray); //saving image in folder
            komentar.resenProblem = 1;
            komentar.oznacenKaoResen = 1;
            komentar.tekst = slika.tekst;
           // _IObavestenjaDAL.dodajKomentar(komentar);
            _context.komentari.Add(komentar);
            _context.SaveChanges();
            return 1;
        }

        public Komentari izmenaKomentara(Komentari izmena)
        {
            var komentara = _context.komentari.FirstOrDefault(k => k.id == izmena.id);
            if (komentara == null) return null;
            komentara.tekst = izmena.tekst;
            _context.SaveChanges();
            return komentara;
        }
    }
}
