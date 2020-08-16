using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL
{
    public class ObjaveBL : IObjaveBL
    {
        private readonly IObjaveDAL _IObjaveDAL;
        private readonly List<Objave> objave;
 
        public ObjaveBL (IObjaveDAL IObjaveDAL)
        {
            _IObjaveDAL = IObjaveDAL;
            objave = _IObjaveDAL.getAllObjave();
        }

        public void deleteObjavuByIdObjave(long idObjave,int ind)
        {
            var objava = this.getObjavaByIdObjave(idObjave);
            _IObjaveDAL.deleteObjavu(objava,ind);
        }

      

        public void deleteObjavuByIdKorisnika(long idKorisnika)
        {
            List<Objave> objave = this.getObjaveByIdKorisnika(idKorisnika);
            _IObjaveDAL.deleteObjave(objave);
            
        }


        public List<Objave> getAllObjave()
        {
            return _IObjaveDAL.getAllObjave();
        }

        public long getIdKorisnikaByIdObjave(long idObjave)
        {
            var objava = objave.SingleOrDefault(o => o.id == idObjave);
            return objava.KorisnikID;
        }

        public Objave getObjavaByIdObjave(long idObjave)
        {
            return objave.FirstOrDefault(o => o.id == idObjave);
        }

        public List<Objave> getObjaveByIdKorisnika(long idKorisnika)
        {
            return objave.Where(o => o.KorisnikID == idKorisnika).ToList();
        }

        

        public void saveObjavu(PrihvatanjeObjave objava)
        {
            _IObjaveDAL.saveObjavu(objava);
        }

        public Objave problemResen(long idObjave,long ind)
        {
            Objave objava = getObjavaByIdObjave(idObjave);
            return _IObjaveDAL.problemResen(objava,ind);
        }

        public List<Objave> getReseneObjave()
        {
            return objave.Where(o => o.resenaObjava > 0).ToList();
        }

        public List<Objave> getObjaveByIdGradova(List<long> idGradova)
        {
            List<Objave> listaObjava = new List<Objave>();
            foreach(var idGrada in idGradova)
            {
                var objaveGradova = this.getObjaveByIdGrada(idGrada);
                if (objaveGradova != null)
                {
                    listaObjava.AddRange(objaveGradova);
                }
            }
            return listaObjava;
        }

        public List<Objave> getObjaveByIdGrada(long idGrada)
        {
            if (idGrada == 0) return objave;
            return objave.Where(o => o.GradID == idGrada).ToList();
        }

        public List<Objave> getReseneObjaveByIdInstitucije(long idInstitucije)
        {
            var reseneObjave = this.getReseneObjave();
            return reseneObjave.Where(o => o.resenaObjava == idInstitucije).ToList();
        }

        public List<Objave> getAllObjaveByIdKorisnika(List<long> nizGradova)
        {
            return this.getObjaveByIdGradova(nizGradova);
        }

        public List<Objave> getReseneObjaveByGradove(List<long> nizGradova)
        {
            List<Objave> listaObjava = new List<Objave>();
            if (nizGradova.Contains(0)) return objave.Where(o => o.resenaObjava > 0).ToList();
            foreach (var idGrada in nizGradova)
            {

                var objaveGradova = objave.Where(o => o.GradID == idGrada && o.resenaObjava > 0);
                if (objaveGradova != null)
                {
                    listaObjava.AddRange(objaveGradova);
                }
            }
            return listaObjava;
        }

        public List<Objave> getNereseneObjaveByGradove(List<long> nizGradova)
        {
            List<Objave> listaObjava = new List<Objave>();
            if (nizGradova.Contains(0)) return objave.Where(o => o.resenaObjava == 0 && o.LepaStvarID == 0).ToList();
            foreach (var idGrada in nizGradova)
            {
         
                var objaveGradova = objave.Where(o => o.GradID == idGrada && o.resenaObjava == 0);
                if (objaveGradova != null)
                {
                    listaObjava.AddRange(objaveGradova);
                }
            }
            return listaObjava; 
        }

        public List<Objave> getReseneObjaveByGrad(long idGrada)
        {
            var lista = this.getObjaveByIdGrada(idGrada);
            return lista.Where(l => l.resenaObjava > 0).ToList();
        }

        public List<Objave> getNereseneObjaveByGrad(long idGrada)
        {
            var lista = this.getObjaveByIdGrada(idGrada);
            return lista.Where(l => l.resenaObjava == 0 && l.LepaStvarID == 0).ToList();
        }

        public List<Objave> getNereseneObjaveByGradZa7Dana(long idGrada)
        {

            var lista = new List<Objave>();
            if (idGrada == 0)
            {
                lista = this.getNereseneObjave();
            }
            else
            {
                lista = this.getNereseneObjaveByGrad(idGrada);
            }
            DateTime datum = DateTime.Now;
            datum = datum.AddDays(-7);
            return lista.Where(l => l.vreme >= datum).ToList();
        }

        public List<Objave> getReseneObjaveByGradZa7Dana(long idGrada)
        {
           var lista = new List<Objave>();
            if (idGrada == 0)
            {
                lista = this.getReseneObjave();
            }
            else
            {
                lista = this.getReseneObjaveByGrad(idGrada);
            } 
           
            DateTime datum = DateTime.Now;
            datum = datum.AddDays(-7);
            return lista.Where(l => l.vreme >= datum).ToList();
        }

        public List<Objave> getNereseneObjave()
        {
            return objave.Where(o => o.resenaObjava == 0 && o.LepaStvarID == 0).ToList();
        }

        public List<Objave> getNereseneProblemeByIdKorinsika(long idKorisnika)
        {
            return objave.Where(o => o.resenaObjava == 0 && o.KorisnikID == idKorisnika).ToList();
        }

        public List<Objave> getReseneProblemeByIdKorinsika(long idKorisnika)
        {
            return objave.Where(o => o.resenaObjava == 1 && o.KorisnikID == idKorisnika).ToList();
        }

        public List<KategorijeProblema> getKategorijeProblema()
        {
            return _IObjaveDAL.getKategorijeProblema();
        }

        public List<LepeStvari> getLepeStavri()
        {
            return _IObjaveDAL.getLepeStavri();
        }

        public List<Objave> getReseneObjaveByGradZa30Dana(long idGrada)
        {
            var lista = new List<Objave>();
            if (idGrada == 0)
            {
                lista = this.getReseneObjave();
            }
            else
            {
                lista = this.getReseneObjaveByGrad(idGrada);
            }

            DateTime datum = DateTime.Now;
            datum = datum.AddDays(-30);
            return lista.Where(l => l.vreme >= datum).ToList();
        }

        public List<Objave> getNereseneObjaveByGradZa30Dana(long idGrada)
        {
            var lista = new List<Objave>();
            if (idGrada == 0)
            {
                lista = this.getNereseneObjave();
            }
            else
            {
                lista = this.getNereseneObjaveByGrad(idGrada);
            }

            DateTime datum = DateTime.Now;
            datum = datum.AddDays(-30);
            return lista.Where(l => l.vreme >= datum).ToList();
        }

        public LepeStvari getLepeStavriById(long LepeStavriID)
        {
            return _IObjaveDAL.getLepeStavriById(LepeStavriID);
        }
    }
}
